package gov.nist.csd.pm.admintool.app.customElements;

import com.vaadin.flow.component.customfield.CustomField;
import com.vaadin.flow.component.html.Paragraph;
import gov.nist.csd.pm.admintool.app.MainView;

import java.util.HashMap;

public class Toggle extends CustomField<String> {
    private final String SELECTED_COLOR = "lightgreen";
    private final String UNSELECTED_COLOR = "white";

    private int numberOfOptions;
    private HashMap<String, Option> optionsMap;

    public Toggle (String defaultValue, String... inputOptions) {
        setStyle();

        setValue(defaultValue);
        numberOfOptions = inputOptions.length;
        optionsMap = new HashMap<>();

        // set up options
        if (numberOfOptions <= 0) {
            throw new IllegalArgumentException("Input must have at least have one option");
        } else if (numberOfOptions == 1) { // solo option
            Option soloOption = new Option(false, inputOptions[0], Position.SOLO);
            add(soloOption);
            optionsMap.put(inputOptions[0], soloOption);

        } else if (numberOfOptions == 2) { // two options: one left, one right
            Option leftOption = new Option(false, inputOptions[0], Position.LEFT);
            add(leftOption);
            optionsMap.put(inputOptions[0], leftOption);

            Option rightOption = new Option(false, inputOptions[1], Position.RIGHT);
            add(rightOption);
            optionsMap.put(inputOptions[1], rightOption);

        } else { // more than two options: one left, n-2 middle, one right
            Option leftOption = new Option(false, inputOptions[0], Position.LEFT);
            add(leftOption);
            optionsMap.put(inputOptions[0], leftOption);

            Option tempMiddleOption;
            for (int i = 1; i < numberOfOptions - 1; i++) {
                tempMiddleOption = new Option(false, inputOptions[i], Position.MIDDLE);
                add(tempMiddleOption);
                optionsMap.put(inputOptions[i], tempMiddleOption);
            }

            Option rightOption = new Option(false, inputOptions[numberOfOptions - 1], Position.RIGHT);
            add(rightOption);
            optionsMap.put(inputOptions[numberOfOptions - 1], rightOption);
        }

        Option valueOption = optionsMap.get(getValue());
        if (valueOption == null) {
            MainView.notify("Default Value is not equal to any of the Inputted Options", MainView.NotificationType.DEFAULT);
        } else {
            valueOption.setSelected(true);
        }
    }

    private void setStyle() {
        setWidthFull();
        getElement().getStyle()
                .set("text-align", "center")
                .set("display", "inline-block")
                .set("justify-content", "center")
                .set("vertical-align", "top")
                .set("margin", "auto")
                .set("user-select", "none");
    }

    @Override
    protected String generateModelValue() {
        return getValue();
    }

    @Override
    protected void setPresentationValue(String s) {
        if (optionsMap != null) {
            optionsMap.values().forEach(option -> option.setSelected(false));
        }
        setValue(s);
    }

    private class Option extends Paragraph {

        public Boolean selected;

        public Option (Boolean selected, String text, Position position) {
            this.selected = selected;

            setText(text);
            setWidth((100.0/numberOfOptions - .5) + "%");
            addClickListener(event -> {
                toggleOn(text);
            });
            getStyle()
                .set("margin", "0")
                .set("padding", "0")
                .set("float", "left")
                .set("border", "1px solid black");

            switch (position) {
                case LEFT:
                    getStyle()
                        .set("border-right", "0.5px solid black")
                        .set("border-radius", "5px 0px 0px 5px");
                    break;
                case MIDDLE:
                    getStyle()
                        .set("border-left", "0.5px solid black")
                        .set("border-right", "0.5px solid black")
                        .set("border-radius", "0");
                    break;
                case RIGHT:
                    getStyle()
                        .set("border-left", "0.5px solid black")
                        .set("border-radius", "0px 5px 5px 0px");
                    break;
                case SOLO:
                    getStyle()
                        .set("border-radius", "5px");
                    break;
            }

            updateToggle();
        }

        public void toggleOn(String value) {
            setPresentationValue(value);
            setSelected(true);
        }

        public void setSelected(Boolean selected) {
            this.selected = selected;
            updateToggle();
        }

        private void updateToggle() {
            if (selected)
                getStyle().set("background", SELECTED_COLOR);
            else
                getStyle().set("background", UNSELECTED_COLOR);
        }
    }

    private enum Position {
        LEFT, MIDDLE, RIGHT, SOLO
    }
}