import 'package:date_format/date_format.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/bussiness/model/time.attention.model.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/shops/ui/payment/pages/model/post.env.parms.delivery.dart';

// ignore: must_be_immutable
class TimeDelivery extends StatefulWidget {
  List<TimeAttentionBusiness> listHours;
  GlobalKey<FormState> formKey;
  ValueChanged<TimedateEnd> onChangedHoursDelivery;
  Business business;
  TimeDelivery(
      {Key key,
      @required this.business,
      @required this.listHours,
      @required this.formKey,
      @required this.onChangedHoursDelivery});
  @override
  _TimeDeliveryState createState() => _TimeDeliveryState();
}

class _TimeDeliveryState extends State<TimeDelivery> {
  bool isTimeDelivery = false;
  bool buttonRefreshDelivery = true;
  final TextEditingController _fechaDeliveryController =
      new TextEditingController();
  final TextEditingController _horaDeliveryController =
      new TextEditingController();
  final formatDateU = DateFormat("yyyy-MM-dd");
  final formatTime = DateFormat("HH:mm");
  Timedate dateform;
  TimedateEnd dateSave;
  String fecharesult = "";
  String horaresult = "";
  ShopRepository _serviceKushiAPI;
  DateTime horayFechaVariable;
  @override
  void initState() {
    _serviceKushiAPI = Ioc.get<ShopRepository>();
    dateform = Timedate();
    dateSave = TimedateEnd();
    calculateDelivery();
    super.initState();
  }

  void calculateDelivery() {
    DateTime now = DateTime.now();
    DateFormat formatDateUP = DateFormat("yyyy-MM-dd");
    ParamsDelivery params = new ParamsDelivery();
    params.date = formatDate(now, [yyyy, '-', mm, '-', dd]);
    params.hour = formatDate(now, [hh, ':', nn, ' ', am]);
    params.type = "2";
    params.idBusiness = widget.business.uid.toString();
    _serviceKushiAPI.queryHourDeliveryRepository(params).then((delivery) {
      if (delivery.status == null) {
        if (delivery.atencion == "NO") {
          alert('No hay atención ');
        } else if (delivery.atencion == "SI") {
          DateTime hourDelivery = DateTime.parse(delivery.fecha);
          horayFechaVariable = hourDelivery;
          String fechaFrom =
              formatDateUP.parse(hourDelivery.toString()).toString();
          setState(() {
            fecharesult = formatDate(hourDelivery, [dd, '/', mm]);
            horaresult = formatDate(hourDelivery, [hh, ':', nn, ' ', am]);
          });
          widget.onChangedHoursDelivery(
              TimedateEnd(fecha: fechaFrom, hora: horaresult));
          setState(() => isTimeDelivery = false);
        } else {
          alert('Algo no va bien, error al procesar petición');
        }
      } else {
        alert('Vaya, internet y yo no nos entendemos');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.car_1,
              color: Theme.of(context).hintColor,
              size: 30,
            ),
            title: Row(
              children: <Widget>[
                Text(
                  'Tiempo de entrega',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline2,
                ),
                buttonRefreshDelivery
                    ? IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          setState(() => isTimeDelivery = true);
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          UiIcons.trash_1,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            buttonRefreshDelivery = true;
                            isTimeDelivery = false;
                          });
                          calculateDelivery();
                        },
                      )
              ],
            ),
            subtitle: Row(
              children: <Widget>[
                Text(
                  'Fecha: ${fecharesult.toString()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Hora: ${horaresult.toString()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          isTimeDelivery
              ? Form(
                  key: widget.formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin:
                            const EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return DateTimeField(
                              format: formatDateU,
                              controller: _fechaDeliveryController,
                              onSaved: (value) => dateform.fecha = value,
                              decoration: getInputDecorationDate(
                                  hintText: '0000/00/00',
                                  labelText: 'Seleccione Fecha'),
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Seleccione la fecha';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin:
                            const EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: DateTimeField(
                          format: formatTime,
                          controller: _horaDeliveryController,
                          onSaved: (value) => dateform.hora = value,
                          decoration: getInputDecorationTime(
                              hintText: '', labelText: 'Seleccione hora'),
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.convert(time);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'seleccione la hora';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RawMaterialButton(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              shape: CircleBorder(),
                              elevation: 2,
                              splashColor: Colors.transparent,
                              fillColor: Theme.of(context).primaryColorDark,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                savefecha();
                              },
                            ),
                            RawMaterialButton(
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              shape: CircleBorder(),
                              elevation: 2,
                              splashColor: Colors.transparent,
                              fillColor: Colors.redAccent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  buttonRefreshDelivery = true;
                                  isTimeDelivery = false;
                                });
                                widget.formKey.currentState.reset();
                                calculateDelivery();
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  InputDecoration getInputDecorationDate({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      icon: Icon(Icons.date_range),
      hintStyle: Theme.of(context).textTheme.bodyText1.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      labelStyle: Theme.of(context).textTheme.bodyText1.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  InputDecoration getInputDecorationTime({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      icon: Icon(Icons.timer),
      hintStyle: Theme.of(context).textTheme.bodyText1.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      labelStyle: Theme.of(context).textTheme.bodyText1.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void savefecha() {
    if (widget.formKey.currentState.validate()) {
      widget.formKey.currentState.save();
      if (dateform.fecha.day == horayFechaVariable.day &&
          dateform.fecha.month == horayFechaVariable.month) {
        if (dateform.hora.hour < horayFechaVariable.hour) {
          alert(
              'El horario de entrega ingresado debe ser mayor al tiempo de entrega programado por kushi app');
        } else if (dateform.hora.hour == horayFechaVariable.hour) {
          if (dateform.hora.minute >= horayFechaVariable.minute) {
            calculeTimePreference(dateform.fecha, dateform);
          } else {
            alert(
                'El horario de entrega ingresado debe ser mayor al tiempo de entrega programado por kushi app');
          }
        } else {
          calculeTimePreference(dateform.fecha, dateform);
        }
      } else {
        alert(
            'Hoy no podemos entregarle su pedido, le recomendamos  escoger el día de mañana');
      }
    }
  }

  void calculeTimePreference(DateTime date, Timedate datefrominfo) {
    if (date == null) {
      widget.formKey.currentState.reset();
      alert('¡El campo Fecha no puede estar vacio!');
    } else {
      switch (date.weekday) {
        case 1:
          final data =
              widget.listHours.where((p) => p.description == "Lunes").toList();
          if (data.length == 0) {
            alert('¡La empresa${widget.business.name}, no atiende los Lunes!');
          } else {
            calculeTime(data[0], datefrominfo);
          }
          break;
        case 2:
          final data =
              widget.listHours.where((p) => p.description == "Martes").toList();
          if (data.length == 0) {
            alert('¡La empresa${widget.business.name}, no atiende los Martes!');
          } else {
            calculeTime(data[0], datefrominfo);
          }
          break;
        case 3:
          final data = widget.listHours
              .where((p) => p.description == "Miercoles")
              .toList();
          if (data.length == 0) {
            alert(
                '¡La empresa${widget.business.name}, no atiende los Miercoles!');
          } else {
            calculeTime(data[0], datefrominfo);
          }
          break;
        case 4:
          final data =
              widget.listHours.where((p) => p.description == "Jueves").toList();
          if (data.length == 0) {
            alert('¡La empresa${widget.business.name}, no atiende los Jueves!');
          } else {
            calculeTime(data[0], datefrominfo);
          }
          break;
        case 5:
          final data = widget.listHours
              .where((p) => p.description == "Viernes")
              .toList();
          if (data.length == 0) {
            alert(
                '¡La empresa${widget.business.name}, no atiende los Viernes!');
          } else {
            calculeTime(data[0], datefrominfo);
          }
          break;
        case 6:
          final data =
              widget.listHours.where((p) => p.description == "Sabado").toList();
          if (data.length == 0) {
            alert(
                '¡La empresa${widget.business.name}, no atiende los Sabados!');
          } else {
            calculeTime(data[0], datefrominfo);
          }
          break;
        case 7:
          final data = widget.listHours
              .where((p) => p.description == "Domingo")
              .toList();
          if (data.length == 0) {
            alert(
                '¡La empresa${widget.business.name}, no atiende los domingos!');
          } else {
            calculeTime(data[0], datefrominfo);
          }
          break;
      }
    }
  }

  void calculeTime(
      TimeAttentionBusiness timedatePreference, Timedate datefrominfo) {
    //DateTime horaAumento = DateTime.parse(widget.business.horaDelivery);
    DateTime horabusiness = DateTime.parse(timedatePreference.hourEnd);
    DateTime horabusinessinit = DateTime.parse(timedatePreference.hourInit);
    DateTime now = DateTime.now();
    DateFormat formatDateUP = DateFormat("yyyy-MM-dd");
    ParamsDelivery params = new ParamsDelivery();
    if (datefrominfo.hora == null) {
      widget.formKey.currentState.reset();
      alert('¡El campo hora no puede estar vacio!');
    } else {
      if (datefrominfo.hora.hour < now.hour &&
          datefrominfo.fecha.day == now.day &&
          datefrominfo.fecha.month == now.month) {
        alert('¡No puede seleccionar horas pasadas!');
      } else {
        int horadelivery = datefrominfo.hora.hour;
        if (horadelivery >= horabusinessinit.hour) {
          if (horabusiness.hour > horadelivery) {
            params.date =
                formatDate(datefrominfo.fecha, [yyyy, '-', mm, '-', dd]);
            params.hour = formatDate(datefrominfo.hora, [hh, ':', nn, ' ', am]);
            params.type = "2";
            params.idBusiness = widget.business.uid.toString();
            _serviceKushiAPI
                .queryHourDeliveryRepository(params)
                .then((delivery) {
              if (delivery.status == null) {
                if (delivery.atencion == "NO") {
                  alert('No hay atención ');
                } else if (delivery.atencion == "SI") {
                  DateTime hourDelivery = DateTime.parse(delivery.fecha);
                  String fechaFrom =
                      formatDateUP.parse(hourDelivery.toString()).toString();
                  setState(() {
                    fecharesult = formatDate(hourDelivery, [dd, '/', mm]);
                    horaresult =
                        formatDate(hourDelivery, [hh, ':', nn, ' ', am]);
                  });
                  widget.onChangedHoursDelivery(
                      TimedateEnd(fecha: fechaFrom, hora: horaresult));
                  widget.formKey.currentState.reset();
                  setState(() {
                    buttonRefreshDelivery = false;
                    isTimeDelivery = false;
                  });
                } else {
                  alert('Algo no encaja bien, error al procesar petición');
                }
              } else {
                alert('Vaya, internet y yo no nos entendemos');
              }
            });
          } else {
            alert('El horario de delivery es \n ' +
                formatDate(horabusinessinit, [hh, ':', nn, ' ', am]) +
                ' hasta ' +
                formatDate(horabusiness, [hh, ':', nn, ' ', am]));
          }
        } else {
          alert('El horario de delivery es \n ' +
              formatDate(horabusinessinit, [hh, ':', nn, ' ', am]) +
              ' hasta ' +
              formatDate(horabusiness, [hh, ':', nn, ' ', am]));
        }
      }
    }
  }

  void alert(String message) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            message,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'Aceptar',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
