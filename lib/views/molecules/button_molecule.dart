import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonMolecule extends StatelessWidget {
  final void Function()? _onPressed;
  final Widget? _icon;
  final String _label;
  final Color? _backgroundColor;
  final bool _stretch;
  final bool _isLoading;
  final bool _isSuccess;

  const ButtonMolecule(
      {required void Function()? onPressed,
      required String label,
      isLoading = false,
      bool stretch = false,
      Color? backgroundColor,
      Widget? icon,
      bool isSuccess = false,
      super.key})
      : _onPressed = onPressed,
        _icon = icon,
        _label = label,
        _backgroundColor = backgroundColor,
        _stretch = stretch,
        _isLoading = isLoading,
        _isSuccess = isSuccess;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: _isLoading || _isSuccess ? null : _onPressed,
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 900),
              margin: EdgeInsets.only(right: _isSuccess ? 10.0 : 0),
              child: SizedBox(
                height: _isSuccess ? 35.0 : 0,
                width: _isSuccess ? 35.0 : 0,
                child: _isSuccess
                    ? const Icon(
                        Icons.done,
                        color: Colors.green,
                        size: 35.0,
                      )
                    : null,
              ),
            ),
            AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 900),
              margin: EdgeInsets.only(right: _isLoading ? 10.0 : 0),
              child: SizedBox(
                height: _isLoading ? 25.0 : 0,
                width: _isLoading ? 25.0 : 0,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 3.0,
                  backgroundColor: getBackgroundColor(context).withOpacity(.3),
                  valueColor:
                      AlwaysStoppedAnimation(getBackgroundColor(context)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  right: _icon == null ? 0.0 : 5.0,
                  left: _icon == null ? 0.0 : 5.0),
              child: SizedBox(
                height: _icon == null ? 0.0 : 25.0,
                width: _icon == null ? 0.0 : 25.0,
                child: _icon,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
            disabledBackgroundColor:
                getBackgroundColor(context).withOpacity(.6),
            backgroundColor: getBackgroundColor(context),
            elevation: 0,
            padding: const EdgeInsets.all(15.0),
            fixedSize: _stretch
                ? Size.fromWidth(MediaQuery.of(context).size.width)
                : const Size.fromWidth(double.infinity),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            )),
        label: Text(
          _label,
          style: GoogleFonts.roboto(fontSize: 16),
        ));
  }

  Color getBackgroundColor(BuildContext context) {
    return _backgroundColor ?? Theme.of(context).primaryColor;
  }
}
