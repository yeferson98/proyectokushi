import 'package:flutter/material.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/user/model/user.model.dart';

// ignore: must_be_immutable
class ProfileSettingsDialog extends StatefulWidget {
  UserModel user;
  VoidCallback onChanged;

  ProfileSettingsDialog({Key key, this.user, this.onChanged}) : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends State<ProfileSettingsDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(UiIcons.user_1),
                    SizedBox(width: 10),
                    Text(
                      'Configuración de perfil',
                      style: Theme.of(context).textTheme.bodyText2,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: widget.user.name + widget.user.lastname,
                              labelText: 'Nombre Completo'),
                          initialValue: widget.user.name,
                          validator: (input) => input.trim().length < 3
                              ? 'Not a valid full name'
                              : null,
                          onSaved: (input) => widget.user.name = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.emailAddress,
                          decoration: getInputDecoration(
                              hintText: 'johndo@gmail.com',
                              labelText: 'Email Address'),
                          initialValue: widget.user.email,
                          validator: (input) =>
                              !input.contains('@') ? 'Not a valid email' : null,
                          onSaved: (input) => widget.user.email = input,
                        ),
                        /*FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return DropdownButtonFormField<String>(
                              decoration: getInputDecoration(hintText: 'Female', labelText: 'Gender'),
                              hint: Text("Select Device"),
                              value: widget.user.,
                              onChanged: (input) {
                                setState(() {
                                  widget.user.gender = input;
                                  widget.onChanged();
                                });
                              },
                              onSaved: (input) => widget.user.gender = input,
                              items: [
                                new DropdownMenuItem(value: 'Male', child: Text('Male')),
                                new DropdownMenuItem(value: 'Female', child: Text('Female')),
                              ],
                            );
                          },
                        ),
                        FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return DateTimeField(
                              decoration: getInputDecoration(hintText: '1996-12-31', labelText: 'Birth Date'),
                              format: new DateFormat('yyyy-MM-dd'),
                              initialValue: widget.user.dateOfBirth,
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                              onSaved: (input) => setState(() {
                                widget.user.dateOfBirth = input;
                                widget.onChanged();
                              }),
                            );
                          },
                        ),*/
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          'Save',
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        "Editar",
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText1.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText1.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_profileSettingsFormKey.currentState.validate()) {
      _profileSettingsFormKey.currentState.save();
      Navigator.pop(context);
    }
  }
}
