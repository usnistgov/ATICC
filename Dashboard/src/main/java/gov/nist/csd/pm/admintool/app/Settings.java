package gov.nist.csd.pm.admintool.app;

import com.vaadin.flow.component.Tag;
import com.vaadin.flow.component.details.Details;
import com.vaadin.flow.component.details.DetailsVariant;
import com.vaadin.flow.component.html.H2;
import com.vaadin.flow.component.html.Paragraph;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.component.textfield.TextField;
import gov.nist.csd.pm.admintool.actions.Action;


@Tag("settings")
public class Settings extends VerticalLayout {
    private HorizontalLayout layout;
    private Details coordinatorURL;

    public Settings() {
        layout = new HorizontalLayout();
        layout.setFlexGrow(1.0);

        add(new H2("Settings:"));
        add(new Paragraph("\n"));

        add(layout);
        setUpLayout();
    }

    private void setUpLayout() {
        setSizeFull();
        setPadding(true);


        // Unit Tester
        TextField URLInput = new TextField();
        URLInput.addValueChangeListener((event) -> {
            if (event.getValue() == null || event.getValue().equals(""))
                Action.coordinatorURL = null;
            else
                Action.coordinatorURL = event.getValue();
        });
        URLInput.setWidth("100%");

        coordinatorURL = new Details("Coordinator URL", null);
        coordinatorURL.setContent(URLInput);
        coordinatorURL.getElement().getStyle()
                .set("background", "#DADADA"); //#A0FFA0
        coordinatorURL.addThemeVariants(DetailsVariant.FILLED);
        coordinatorURL.addOpenedChangeListener(e -> {
            if (e.isOpened()) {
                if (Action.coordinatorURL == null)
                    URLInput.setValue("");
                else {
                    URLInput.setValue(Action.coordinatorURL);
                }
            }
        });
        add(coordinatorURL);
    }
}
