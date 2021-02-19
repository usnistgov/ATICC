package gov.nist.csd.pm.admintool.app;

import com.vaadin.flow.component.AbstractField;
import com.vaadin.flow.component.accordion.Accordion;
import com.vaadin.flow.component.accordion.AccordionPanel;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.combobox.ComboBox;
import com.vaadin.flow.component.details.DetailsVariant;
import com.vaadin.flow.component.html.Span;
import com.vaadin.flow.component.icon.VaadinIcon;
import com.vaadin.flow.component.orderedlayout.FlexComponent;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.component.textfield.IntegerField;
import com.vaadin.flow.component.textfield.TextField;
import gov.nist.csd.pm.admintool.actions.Action;
import gov.nist.csd.pm.admintool.actions.SingletonActiveActions;
import gov.nist.csd.pm.admintool.actions.scenarios.Ping;
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
                if (!filledParams()) {
                    MainView.notify("Parameters are not filled.", MainView.NotificationType.ERROR);
                } else {
                    actions.add(chosenTest);
                    refreshComponent();
                }
            } else {
                MainView.notify("No Test", MainView.NotificationType.DEFAULT);
            }
        });
        form.add(test);

        // actual combo box
        testSelect = new ComboBox<>("Tests");
        testSelect.setItems("Ping"); // todo: add the rest of the test types
        testSelect.setRequiredIndicatorVisible(true);
        testSelect.setPlaceholder("Select an option");
        testSelect.addValueChangeListener(event -> {
            if (!event.getSource().isEmpty()) {
                // todo: add the rest of the test types
                switch (event.getValue()) {
                    case "Ping":
                        params.removeAll();
                        chosenTest = new Ping();
                        break;
                }
                if (chosenTest != null) {
                    Map<String, Action.Type> paramsTypes = chosenTest.getParamNamesAndTypes();
                    for (String paramName : paramsTypes.keySet()) {
                        switch (paramsTypes.get(paramName)) {
                            case STRING:
                                TextField textField = new TextField();
                                textField.setLabel(paramName);
                                textField.setPlaceholder("Enter String...");
                                textField.addValueChangeListener(textEvent -> {
                                    if (textEvent.getValue() != null) {
                                        chosenTest.setParamValue(paramName, textEvent.getValue());
                                    }
                                });
                                //textField.setValue("");
                                params.add(textField);
                                break;
                            case INT:
                                IntegerField integerField = new IntegerField();
                                integerField.setLabel(paramName);
                                integerField.setHasControls(true);
                                integerField.setPlaceholder("Enter Number...");
                                integerField.addValueChangeListener(integerEvent -> {
                                    if (integerEvent.getValue() != null) {
                                        chosenTest.setParamValue(paramName, integerEvent.getValue());
                                    }
                                });
                                //integerField.setValue();
                                params.add(integerField);
                                break;
                        }
                    }
                }
            }
        });

        form.add(testSelect);
        Button refresh = new Button("Refresh", event -> {
            SingletonActiveActions.removeAllResponses();
            refreshComponent();
        });
        refresh.getElement().getStyle().set("margin-left", "auto");
        form.add(params);
        form.add(refresh);

        add(form);
    }

    private boolean filledParams() {
        boolean paramsFilled = true;
        Object[] parameterInputs = params.getChildren().toArray();
        for (Object c: parameterInputs) {
            if (c instanceof AbstractField) {
                paramsFilled &= !((AbstractField<?, ?>) c).isEmpty();
            }
        }
        return paramsFilled;
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
            VerticalLayout auditLayout = new VerticalLayout();
            AccordionPanel regularPannel = results.add(action.toString(), auditLayout);
            if (action.resolve()) { // passed
                regularPannel.getElement().getStyle().set("background", "#BEFFB5"); // passed
            } else { // failed
                regularPannel.getElement().getStyle().set("background", "#FFBFB5"); // failed
            }
            String audit = action.explain();
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
            regularPannel.addThemeVariants(DetailsVariant.FILLED, DetailsVariant.REVERSE);
            results.close();
        }
    }

    public void refreshComponent() {
        chosenTest = null;
        testSelect.setValue(null);
        params.removeAll();
        refreshListOfTests();
        MainView.refreshTestResults();
    }
}
