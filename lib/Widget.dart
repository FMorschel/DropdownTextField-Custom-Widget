import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

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

  final Duration delayTime;
  final bool delay;

  const DropdownText({Key key, this.border, this.borderColor, this.borderWidth,
    this.borderRadius, this.padding, @required this.options, this.iconColor, 
    this.textStyle, this.iconSize, this.maxlistHeight, this.caseSensitive,
    this.label, this.labelText, this.controller, 
    this.focusNode, this.delayTime, this.delay}) : super(key: key);

  @override
  _DropdownTextState createState() => _DropdownTextState();
}

class _DropdownTextState extends State<DropdownText> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  TextEditingController _controller;
  FocusNode _focusNode;

  BorderStyle border = BorderStyle.none;
  Color borderColor = Colors.blueGrey;
  double borderWidth = 2.0;
  double borderRadius = 20.0;
  Color iconColor = Colors.blueGrey;
  double size;
  List<String> options;
  List<String> list = [];
  bool caseSensitive;
  bool label;

  Duration delayTime;
  bool delay;

  bool _show = false;
  String input = "";

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
    _focusNode.addListener(focusListener);
    _controller.addListener(controllerListener);
    caseSensitive = widget.caseSensitive ?? false;
    label = widget.label ?? false;
    size = 25.0;
    delay = widget.delay ?? true;
    delayTime = widget.delayTime ?? Duration(milliseconds: 100);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }


  void controllerListener(){
    if(_focusNode.hasFocus){
      if(input.length != _controller.text.length){
        _show = true;
        _editList();
      }
      input = _controller.text;
    }
  }

  void focusListener(){
    if(_focusNode.hasFocus){
      _show = true;
    }else _show = false;
    setState(() {});
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
        if(!_focusNode.hasFocus){
          _show = !_show;
          if(_listKey.currentState != null) _editList(text: "");
        }else{
          _show = false;
          if(_focusNode.hasFocus) _focusNode.unfocus();
        }
        setState(() {});
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
                _showList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool removeItems(String text){
    Future<Null> future = Future(() {});
    bool rem = false;

    for (int i =  list.length - 1; i >= 0; i--) {
      if(!(caseSensitive ? list[i].startsWith(text) : list[i].toLowerCase().startsWith(text.toLowerCase()))){
        rem = true;
        if(delay){
          future = future.then((_) {
            return Future.delayed(delayTime, () {
              final String deletedItem = list.removeAt(i);
              _listKey.currentState.removeItem(
                i,
                (BuildContext context, Animation<double> animation) => _removeAnimation(context, deletedItem, animation)
              );
            });
          });
        }else{
          final String deletedItem = list.removeAt(i);
          _listKey.currentState.removeItem(
            i, 
            (BuildContext context, Animation<double> animation) => _removeAnimation(context, deletedItem, animation)
          );
        }
      }
    }
    return rem;
  }

  void insertItems(String text){
    Future<Null> future = Future(() {});
    int index = list.length;

    for(int i = 0; i < options.length; i++){
      if(caseSensitive ? options[i].startsWith(text) : options[i].toLowerCase().startsWith(text.toLowerCase())
      && !list.contains(options[i])){
        if(delay){
          future = future.then((_) {
            return Future.delayed(delayTime, () {
              list.add(options[i]);
              _listKey.currentState.insertItem(index++);
            });
          });
        }else{
          list.add(options[i]);
          _listKey.currentState.insertItem(index++);
        }
      }
    }
  }

  void _editList({String text}){

    String _text = text ?? _controller.text.trim() ?? "";
    bool rem = false;
    if(_show){
      rem = removeItems(_text);
      if(!rem) insertItems(_text);
    }

  }

  Widget _showList(){

    if(_show){
      
      if(list.length == 0) options.forEach((option){
        list.add(option);
      });
      if(_controller.text.trim().isNotEmpty){
        for (int i =  list.length - 1; i >= 0; i--) {
          if(!(caseSensitive ? list[i].startsWith(_controller.text.trim()) : list[i].toLowerCase().startsWith(_controller.text.trim().toLowerCase()))){
            list.removeAt(i);
          }
        }
      }

      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 0.0),
            child: Divider(color: Colors.blueGrey[700],),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.maxlistHeight ?? 200, minHeight: 1.0),
            child: AnimatedList(
              key: _listKey,
              shrinkWrap: true,
              initialItemCount: list.length,
              itemBuilder: (BuildContext context, int index, Animation animation) {
                return _buildAnimation(context, index, animation);
              },
            ),
          ),
        ],
      );
    }else{
      return SizedBox(width: 0.0, height: 0.0,);
    }

  }

  Widget _removeAnimation(BuildContext context, String text, Animation<double> animation){
    return SlideTransition(
      position: animation.drive(
        Tween(
          begin: Offset(1, 0),
          end: Offset(0, 0),
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
      ),
      child: _itemCard(context, text),
    );
  } 

  Widget _buildAnimation(BuildContext context, int index, Animation<double> animation){

    return SlideTransition(
      position: animation.drive(
        Tween(
          begin: Offset(1, 0),
          end: Offset(0, 0),
        ).chain(CurveTween(curve: Curves.easeIn)),
      ),
      child: _itemCard(context, list[index]),
    );

  }

  Widget _itemCard(BuildContext context, String text){

    return GestureDetector(
      onTap: (){
        _show = false;
        setState(() {});
        if(_focusNode.hasFocus) _focusNode.unfocus();
        _controller.text = text;
      },
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.symmetric(horizontal: 13.0, vertical: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(text,
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