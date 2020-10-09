package gov.nist.csd.pm.admintool.app.customElements;

import com.vaadin.flow.component.AbstractField;
import com.vaadin.flow.component.Component;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.button.ButtonVariant;
import com.vaadin.flow.component.html.Div;
import com.vaadin.flow.component.icon.Icon;
import com.vaadin.flow.component.icon.VaadinIcon;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import gov.nist.csd.pm.admintool.app.MainView;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class MapInput<K, V> extends VerticalLayout {
    private Set<Row> rows = new HashSet<>();

    private Class keyField, valueField;
    private FieldConfig keyFieldConfig, valueFieldConfig;
    private FieldRetriever<K> keyFieldRetriever;
    private FieldRetriever<V> valueFieldRetriever;
    private HorizontalLayout labelSection;
    private Div label;
    private Div rowsSection;

    public MapInput(Class keyField, Class valueField,
                    FieldConfig keyFieldConfig, FieldConfig valueFieldConfig,
                    FieldRetriever keyFieldRetriever, FieldRetriever valueFieldRetriever) {
        this.keyField = keyField;
        this.valueField = valueField;

        this.keyFieldConfig = keyFieldConfig;
        this.valueFieldConfig = valueFieldConfig;

        this.keyFieldRetriever = keyFieldRetriever;
        this.valueFieldRetriever = valueFieldRetriever;


        // ----- label section -----
        labelSection = new HorizontalLayout();
        labelSection.setPadding(false);
        labelSection.setMargin(false);
        add(labelSection);

        // actual label
        label = new Div();
        label.getStyle()
                .set("font-size", "13px");
        labelSection.add(label);

        // new row button
        Div newRowButton = new Div();
        newRowButton.setText("+");
        newRowButton.addClickListener((buttonClickEvent) -> {
            addRow(null, null);
        });
        newRowButton.getStyle()
                .set("font-size", "13px")
                .set("color", "blue")
                .set("cursor", "pointer");
        labelSection.add(newRowButton);


        // ----- rows section -----
        rowsSection = new Div();
        rowsSection.getStyle().set("margin", "0").set("padding", "0");
        add(rowsSection);

        getStyle().remove("width");
    }


    private void addRow (K key, V value) {
        Row newRow = new Row(key, value);
        rows.add(newRow);
        rowsSection.add(newRow);
    }

    public void deleteRow (Row row) {
        if (rows.contains(row)) {
            rows.remove(row);
            rowsSection.remove(row);
        }
    }

    public void setLabel (String label) {
//        this.getElement().setProperty("label", label != null ? label : "");
        this.label.setText(label);
    }

    public Map<K, V> getValue() throws Exception {
        Map<K, V> ret = new HashMap<>();
        for (Row row : rows) {
            if (row.getKey() != null) {
                if (ret.containsKey(row.getKey())) {
                    throw new Exception("Duplicate Key");
                } else {
                    ret.put(row.getKey(), row.getValue());
                }
            }

        }
        return ret;
    }

    public void setValue (Map<K, V> fieldValue) {
        if (!fieldValue.isEmpty()) {
            rows.clear();
            rowsSection.removeAll();

            for (K key: fieldValue.keySet()) {
                addRow(key, fieldValue.get(key));
            }
        }
    }

    private class Row extends HorizontalLayout {
        private AbstractField keyFieldInstance, valueFieldInstance;

        private Row(K key, V value) {
            setAlignItems(Alignment.CENTER);

            Button deleteButton = new Button(new Icon(VaadinIcon.MINUS));
            deleteButton.addThemeVariants(ButtonVariant.LUMO_ERROR);
            deleteButton.addClickListener(buttonClickEvent -> deleteRow(this));
            add(deleteButton);

            try {
                Object keyFieldObject = keyField.newInstance();
                if (keyFieldObject instanceof AbstractField) {
                    keyFieldInstance = (AbstractField) keyFieldObject;
                    if (keyFieldConfig != null)
                        keyFieldConfig.config(keyFieldInstance);
                    if (key != null)
                        keyFieldInstance.setValue(key);

                    // duplicate key notifier
                    keyFieldInstance.addValueChangeListener((valueChangeEvent) -> {
                        rows.forEach((row -> {
                            if (!row.equals(this)) {
                                if (valueChangeEvent.getValue().equals(row.getKey())) {
                                    MainView.notify("Duplicate Key");
                                }
                            }
                        }));
                    });
                    add(keyFieldInstance);
                }

                Object valueFieldObject = valueField.newInstance();
                if (valueFieldObject instanceof AbstractField) {
                    valueFieldInstance = (AbstractField) valueFieldObject;
                    if (valueFieldConfig != null)
                        valueFieldConfig.config(valueFieldInstance);
                    if (value != null)
                        valueFieldInstance.setValue(value);
                    add(valueFieldInstance);
                }
            } catch (InstantiationException e) {
                MainView.notify(e.getMessage(), MainView.NotificationType.ERROR);
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                MainView.notify(e.getMessage(), MainView.NotificationType.ERROR);
                e.printStackTrace();
            }
        }

        public Component getKeyFieldInstance() { return keyFieldInstance; }
        public Component getValueFieldInstance() { return valueFieldInstance; }

        public K getKey() {
            if (keyFieldRetriever != null)
                return (K) keyFieldRetriever.retrieve(keyFieldInstance);
            else
                return (K) keyFieldInstance.getValue();
        }
        public V getValue() {
            if (valueFieldRetriever != null)
                return (V) valueFieldRetriever.retrieve(valueFieldInstance);
            else
                return (V) valueFieldInstance.getValue();
        }
        public void setKey(K key) {  keyFieldInstance.setValue(key); }
        public void setValue(V value) { valueFieldInstance.setValue(value); }
    }

    @FunctionalInterface
    public interface FieldConfig {
        void config(AbstractField field);
    }

    @FunctionalInterface
    public interface FieldRetriever<T> {
        T retrieve(AbstractField field);
    }
}
