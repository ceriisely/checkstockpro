import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  final InputFormValue formValue;

  const InputTextField({Key? key, required this.formValue}) : super(key: key);

  @override
  _InputTextField createState() => _InputTextField();
}

class _InputTextField extends State<InputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      textInputAction: TextInputAction.next,
      controller: widget.formValue.value,
      decoration: InputDecoration(
          hintText: widget.formValue.hint,
          labelText: widget.formValue.title,
          suffixIcon: IconButton(
            onPressed: () async {
              var newDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );

              // Don't change the date if the date picker returns null.
              if (newDate == null) {
                return;
              }

              widget.formValue.onChanged!(newDate);
            },
            icon: Icon(widget.formValue.icon),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromRGBO(228, 228, 228, 1), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromRGBO(228, 228, 228, 1), width: 2.0),
          )),
      // autofillHints: const [AutofillHints.givenName],
    );
  }
}

class InputFormValue {
  final String title;
  final String hint;
  final TextEditingController? value;
  final IconData? icon;
  final ValueChanged<DateTime>? onChanged;

  const InputFormValue(
      {required this.title,
      required this.hint,
      this.value,
      this.icon,
      this.onChanged});
}

var defaultFocusedBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color.fromRGBO(228, 228, 228, 1), width: 2.0),
);
var defaultBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color.fromRGBO(228, 228, 228, 1), width: 2.0),
);
var errorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red, width: 2.0),
);
var noBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.transparent, width: 0),
);
