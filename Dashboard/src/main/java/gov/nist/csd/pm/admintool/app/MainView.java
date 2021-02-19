package gov.nist.csd.pm.admintool.app;

import com.vaadin.flow.component.Component;
import com.vaadin.flow.component.html.Div;
import com.vaadin.flow.component.html.H3;
import com.vaadin.flow.component.html.Paragraph;
import com.vaadin.flow.component.icon.Icon;
import com.vaadin.flow.component.icon.VaadinIcon;
import com.vaadin.flow.component.notification.Notification;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.component.tabs.Tab;
import com.vaadin.flow.component.tabs.Tabs;
import com.vaadin.flow.router.Route;
import gov.nist.csd.pm.admintool.actions.Action;
import gov.nist.csd.pm.admintool.actions.SingletonActiveActions;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Route
public class MainView extends HorizontalLayout{
    private static Div testResults;
    private Div pages;
    private static SingletonActiveActions actions;

    private VerticalLayout navbar;

    public MainView() {
        testResults = new Div();
        actions = SingletonActiveActions.getInstance();
        navbar = new VerticalLayout();
        navbar.setWidth("16%");
        navbar.setJustifyContentMode(JustifyContentMode.START);
        navbar.getStyle()
                .set("border-right", "1px solid #FFF3D3")
                .set("height", "100vh")
                .set("background", "#FFF3D3");

        H3 title = new H3("ATICC Dashboard");
        title.getStyle().set("user-select", "none");
        navbar.add(title);

        Tab tab1 = new Tab("Info Page");
        VerticalLayout page1 = new VerticalLayout();
        page1.setSizeFull();

        Tab tab2 = new Tab("Test Config");
        VerticalLayout page2 = new Tester();
        page2.setSizeFull();
        page2.setVisible(false);

        Tab tab3 = new Tab("Results");
        VerticalLayout page3 = new VerticalLayout();
        page3.setSizeFull();
        page2.setVisible(false);

        Tab tab4 = new Tab("Settings");
        VerticalLayout page4 = new Settings();
        page4.setSizeFull();
        page4.setVisible(false);

        Tabs tabs = new Tabs(tab1, tab2, tab3, tab4);
        tabs.setOrientation(Tabs.Orientation.VERTICAL);
        tabs.setFlexGrowForEnclosedTabs(1);
        navbar.add(tabs);

        Map<Tab, Component> tabsToPages = new HashMap<>();
        tabsToPages.put(tab1, page1);
        tabsToPages.put(tab2, page2);
        tabsToPages.put(tab3, page3);
        tabsToPages.put(tab4, page4);

        pages = new Div(page1, page2, page3, page4);
        pages.setSizeFull();

        Set<Component> pagesShown = Stream.of(page1)
                .collect(Collectors.toSet());
        tabs.addSelectedChangeListener(event -> {
            pagesShown.forEach(page -> page.setVisible(false));
            pagesShown.clear();
            Component selectedPage = tabsToPages.get(tabs.getSelectedTab());
            selectedPage.setVisible(true);
            pagesShown.add(selectedPage);

        });

        testResults.getStyle()
                .set("overflow-y", "hidden")
                .set("position", "absolute")
                .set("bottom", "0")
                .set("left", "0");
        testResults.setWidth("16%");
        testResults.setHeight("10%");
        refreshTestResults();
        navbar.add(testResults);

        add(navbar);
        add(pages);
    }

    public static void refreshTestResults() {
        testResults.removeAll();
        for (Action action: actions) {
            Icon line = new Icon(VaadinIcon.LINE_V);
            if (action.resolve()) {
                line.setColor("green");
            } else {
                line.setColor("red");
            }
            testResults.add(line);
        }
    }

    public static void notify(String message, NotificationType type) {
        Paragraph text = new Paragraph(message);
        switch(type) {
            case SUCCESS:
                text.getStyle().set("color", "#009933"); //success
                break;
            case ERROR:
                text.getStyle().set("color", "#990033"); //error
                break;
            case DEFAULT:
            default:
                break;
        }
        Notification notif = new Notification(text);
        notif.setDuration(3000);
        notif.open();
    }

    public static void notify(String message) {
        notify(message, NotificationType.DEFAULT);
    }

    public enum NotificationType {
        SUCCESS, ERROR, DEFAULT
    }

}
