package gov.nist.csd.pm.admintool.app.testingApps;

import com.vaadin.flow.component.accordion.Accordion;
import com.vaadin.flow.component.accordion.AccordionPanel;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.combobox.ComboBox;
import com.vaadin.flow.component.details.DetailsVariant;
import com.vaadin.flow.component.html.Span;
import com.vaadin.flow.component.orderedlayout.FlexComponent;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import gov.nist.csd.pm.admintool.actions.Action;
import gov.nist.csd.pm.admintool.actions.SingletonActiveActions;
import gov.nist.csd.pm.admintool.app.MainView;
import java.util.Map;

public class UnitTester extends VerticalLayout {
    private SingletonActiveActions actions;
    private ComboBox<String> testSelect;
    private Action chosenTest;
    private Accordion results;
    private HorizontalLayout params;

    public UnitTester () {
        setPadding(false);
        setMargin(false);
        setWidthFull();
        setAlignItems(Alignment.CENTER);
        setJustifyContentMode(JustifyContentMode.START);

        params = new HorizontalLayout();

        actions = SingletonActiveActions.getInstance();
        results = new Accordion();
        refreshListOfTests();

        testSelect = new ComboBox<>("Tests");
        // TODO: replace with our list of tests
//        testSelect.setItems("Assert Association", "Assert Assignment", "Check Permission",
//                "Assign Event", "Deassign Event", "Deassign From Event");
        chosenTest = null;

        addTestSelectForm();
        addListOfTests();
    }

    private void addTestSelectForm() {
        HorizontalLayout form = new HorizontalLayout();
        form.setAlignItems(FlexComponent.Alignment.BASELINE);
        form.setWidthFull();
        form.setMargin(false);

        params.setAlignItems(FlexComponent.Alignment.BASELINE);
        params.setMargin(false);

        Button test = new Button("+", event -> {
            if (chosenTest != null) {
                actions.add(chosenTest);
                refreshComponent();
            } else {
                MainView.notify("No Test", MainView.NotificationType.DEFAULT);
            }
        });
        form.add(test);

        // actual combo box
        testSelect.setRequiredIndicatorVisible(true);
        testSelect.setPlaceholder("Select an option");
        testSelect.addValueChangeListener(event -> {
            if (!event.getSource().isEmpty()) {
                // TODO: Instantiate each new test
                switch (event.getValue()) {
                    case "Assert Association":
                        params.removeAll();
//                        chosenTest = new AssertAssociation();
                        break;
                    case "Assert Assignment":
                        params.removeAll();
//                        chosenTest = new AssertAssignment();
                        break;
                    case "Check Permission":
                        params.removeAll();
//                        chosenTest = new CheckPermission();
                        break;
                    case "Assign Event":
                        params.removeAll();
//                        chosenTest = new AssignEvent();
                        break;
                    case "Deassign Event":
                        params.removeAll();
//                        chosenTest = new DeassignEvent();
                        break;
                    case "Deassign From Event":
                        params.removeAll();
//                        chosenTest = new DeassignFromEvent();
                        break;
                }
                if (chosenTest != null) {
                    Map<String, Action.Type> info = chosenTest.getParamNamesAndTypes();
                    for (String key : info.keySet()) {
                        // TODO: Configure each type of parameter
//                        switch (info.get(key)) {
//                            case STRING:
//                                TextField textField = new TextField();
//                                textField.setLabel(key);
//                                textField.setPlaceholder("Select String");
//                                textField.addValueChangeListener(textEvent -> {
//                                    String selected = textEvent.getValue();
//                                    if (selected != null) {
//                                        tempTest.setParamValue(key, selected);
//                                    }
//                                });
//                                params.add(textField);
//                                break;
//                        }
                    }
                }
            }
        });

        form.add(testSelect);
        form.add(params);

        add(form);
    }

    private void addListOfTests() {
        results.setWidthFull();
        results.getElement().getStyle()
                .set("overflow-y", "scroll");
        add(results);

        refreshListOfTests();
    }

    private void refreshListOfTests() {
        results.getChildren().forEach(c -> {
            results.remove(c);
        });
        for (Action action: actions) {
            String audit = action.explain();
            VerticalLayout auditLayout = new VerticalLayout();
            auditLayout.setSizeFull();
            auditLayout.getStyle()
                    .set("padding-bottom", "0px");
            String[] split = audit.split("\n");
            if (split.length > 1) {
                for (String line : split) {
                    Span lineSpan = new Span(line);
                    int tabs = 0;
                    while (line.startsWith("\t")) {
                        tabs++;
                        line = line.substring(1);
                    }
                    lineSpan.getStyle()
                            .set("margin", "0")
                            .set("padding-left", ((Integer) (tabs * 25)).toString() + "px")
                            .set("padding", "0");
                    auditLayout.add(lineSpan);
                }
            } else {
                auditLayout.add(new Span(audit));
            }
            AccordionPanel regularPannel = results.add(action.toString(), auditLayout);
            if (action.run()) { // passed
                regularPannel.getElement().getStyle().set("background", "#BEFFB5"); // passed
            } else { // failed
                regularPannel.getElement().getStyle().set("background", "#FFBFB5"); // failed
            }
            regularPannel.addThemeVariants(DetailsVariant.FILLED, DetailsVariant.REVERSE);
            results.close();
        }
    }

    public void refreshComponent() {
        chosenTest = null;
        testSelect.setValue(null);
        params.removeAll();
        refreshListOfTests();
    }
}
