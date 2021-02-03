package gov.nist.csd.pm.admintool.app;

import com.vaadin.flow.component.Tag;
import com.vaadin.flow.component.details.Details;
import com.vaadin.flow.component.details.DetailsVariant;
import com.vaadin.flow.component.html.H2;
import com.vaadin.flow.component.html.Paragraph;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;

@Tag("tester")
public class Tester extends VerticalLayout {
    private HorizontalLayout layout;
    private UnitTester unitTester;
    private Details unitTests;

    public Tester() {
        layout = new HorizontalLayout();
        layout.setFlexGrow(1.0);

        add(new H2("All Tests:"));

        unitTests = new Details("Unit Tests", null);

        add(new Paragraph("\n"));

        add(layout);
        setUpLayout();
    }

    private void setUpLayout() {
        setSizeFull();
        setPadding(true);


        // Unit Tester
        unitTester = new UnitTester();
        unitTester.setWidth("100%");
        unitTests.setContent(unitTester);
        unitTests.getElement().getStyle()
                .set("background", "#DADADA"); //#A0FFA0
        unitTests.addThemeVariants(DetailsVariant.FILLED);
        unitTests.addOpenedChangeListener(e -> {
            if (e.isOpened()) {
                unitTester.refreshComponent();
            }
        });
        add(unitTests);
    }
}
