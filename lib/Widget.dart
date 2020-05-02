import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DropdownText extends StatefulWidget {

  final TextStyle textStyle;
  final bool label;
  final String labelText;

  final BorderStyle border;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsets padding;

  final Color iconColor;
  final double iconSize;
  final List<String> options;
  final double maxlistHeight;

  final bool caseSensitive;
  final TextEditingController controller;
  final FocusNode focusNode;

  const DropdownText({Key key, this.border, this.borderColor, this.borderWidth,
    this.borderRadius, this.padding, @required this.options, this.iconColor, 
    this.textStyle, this.iconSize, this.maxlistHeight, this.caseSensitive,
    this.label, this.labelText, this.controller, 
    this.focusNode}) : super(key: key);

  @override
  _DropdownTextState createState() => _DropdownTextState();
}

class _DropdownTextState extends State<DropdownText> {

  TextEditingController _controller;

  FocusNode _focusNode;

  BorderStyle border = BorderStyle.none;
  Color borderColor = Colors.blueGrey;
  double borderWidth = 2.0;
  double borderRadius = 20.0;
  Color iconColor = Colors.blueGrey;
  double size;
  List<String> options;
  bool caseSensitive;
  bool label;

  bool _show = false;

  TextStyle _textStyle = TextStyle(
    color: Colors.black,
    fontSize: 25.0,
  );

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) _controller = widget.controller;
    else _controller = TextEditingController();
    if (widget.focusNode != null) _focusNode = widget.focusNode;
    else _focusNode = FocusNode();
    options = widget.options;
    _focusNode.addListener(listener);
    _controller.addListener(listener);
    caseSensitive = widget.caseSensitive ?? false;
    label = widget.label ?? false;
    size = 25.0;
  }

  void listener(){
    if(_focusNode.hasFocus){
      setState(() {
        _show = true;
      });
    }else{
      setState(() {
        _show = false;
      });
    }
  }

  BoxDecoration _boxDecoration(){

    return BoxDecoration(
      border: Border.all(
        color: widget.borderColor ?? borderColor,
        style: widget.border ?? border,
        width: widget.borderWidth ?? borderWidth,
      ),
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? borderRadius))
    );

  }

  Widget _textField(){

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 4.0, 4.0, 0.0),
        child: TextField(
          style: widget.textStyle ?? _textStyle,
          focusNode: _focusNode,
          controller: _controller,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );

  }

  Widget _label(){

    return label ? Padding(
      padding: EdgeInsets.all(size),
      child: Text(widget.labelText ?? "Label",
        style: widget.textStyle ?? _textStyle,
      ),
    ) : Container(width: 1.0, height: 1.0,);

  }

  Widget _button(){

    return GestureDetector(
      onTap: () {
        setState(() {
          if(!_focusNode.hasFocus){
            _show = !_show;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: widget.iconSize ?? size, 
            minWidth: widget.iconSize ?? size,
          ),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: widget.iconColor ?? iconColor,
            size: widget.iconSize ?? size,
          ),
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _label(),
        Expanded(
          child: Container(
            margin: widget.padding ?? EdgeInsets.only(left: 0.0),
            decoration: _boxDecoration(), 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _textField(),
                    _button(),
                  ],
                ),
                _showList(_show, text: _focusNode.hasFocus ? _controller.text.trim() ?? "": ""),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _showList(bool show, {String text = ""}){

    List<String> list = [];

    options.forEach((option){
      if(caseSensitive ? option.startsWith(text) : option.toLowerCase().startsWith(text.toLowerCase())){
        list.add(option);
      }
    });

    if(list.length > 0 && show){
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 0.0),
            child: Divider(color: Colors.blueGrey[700],),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.maxlistHeight ?? 200, minHeight: 1.0),
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index){
                return _itemCard(context, index, list);
              }
            ),
          ),
        ],
      );
    }else{
      return SizedBox(width: 1.0, height: 1.0,);
    }

  }

  Widget _itemCard(BuildContext context, int index, List<String> list){

    return GestureDetector(
      onTap: (){
        setState(() {
          _controller.text = list[index];
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 13.0, vertical: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(list[index],
                  style: widget.textStyle ?? _textStyle,
                )
              ],
            ),
            Divider(color: Colors.blueGrey[700],),
          ],
        ),
      ),
    );

  }

}