package gov.nist.csd.pm.admintool.app;

import com.vaadin.flow.component.Text;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.html.H3;
import com.vaadin.flow.component.orderedlayout.FlexComponent;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;

public class TitleFactory {
    public static HorizontalLayout generate(String titleText, String subtitleText, Button submitButton) {
        VerticalLayout titleLayout1 = new VerticalLayout();
        titleLayout1.setJustifyContentMode(FlexComponent.JustifyContentMode.END);
        titleLayout1.setAlignItems(FlexComponent.Alignment.START);
        titleLayout1.setPadding(false);
        titleLayout1.setWidth("85%");
        H3 title = new H3(titleText);
        title.getStyle().set("margin-bottom", "0px");
        if (subtitleText != null) {
            Text subtitle = new Text(subtitleText);
            titleLayout1.add(title, subtitle);
        } else {
            titleLayout1.add(title);
        }

        HorizontalLayout totalTitleLayout = new HorizontalLayout();
        if (submitButton != null) {
            VerticalLayout titleLayout2 = new VerticalLayout();
            titleLayout2.setJustifyContentMode(FlexComponent.JustifyContentMode.END);
            titleLayout2.setAlignItems(FlexComponent.Alignment.END);
            titleLayout2.setPadding(false);
            titleLayout2.setWidth("15%");
            titleLayout2.add(submitButton);
            totalTitleLayout.add(titleLayout1, titleLayout2);
        } else {
            totalTitleLayout.add(titleLayout1);
        }
        totalTitleLayout.setWidthFull();
        return totalTitleLayout;
    }
    public static HorizontalLayout generate(String titleText, Button submitButton) {
        return generate(titleText, null, submitButton);
    }
    public static HorizontalLayout generate(String titleText, String subtitleText) {
        return generate(titleText, subtitleText, null);
    }
    public static HorizontalLayout generate(String titleText) {
        return generate(titleText, null, null);
    }
}
