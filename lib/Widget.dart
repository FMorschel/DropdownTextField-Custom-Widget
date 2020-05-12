import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

class DropdownText extends StatefulWidget {

  final bool autocorrect;
  final bool autofocus;
  final BorderStyle border;  
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Widget Function(BuildContext, {int currentLength, bool isFocused, int maxLength}) buildCounter;
  final bool caseSensitive;  
  final TextEditingController controller;
  final Color cursorColor;
  final Radius cursorRadius;
  final double cursorWidth;
  final InputDecoration decoration; 
  final bool delay;
  final Duration delayTime;
  final bool divider;
  final bool enabled;
  final bool enableInteractiveSelection;
  final bool enableSuggestions;
  final FocusNode focusNode;
  final Widget icon;
  final List<TextInputFormatter> inputFormatters;
  final Widget Function(BuildContext, String) item;
  final Widget Function(BuildContext, Widget, Animation<double>) itemBuilder;
  final Widget Function(BuildContext, Widget, Animation<double>) itemRemover;
  final Brightness keyboardAppearance;
  final TextInputType keyboardType;
  final bool label;
  final Text labelText;
  final bool listEnabled;
  final int maxLength;
  final bool maxLengthEnforced;
  final int maxLines;
  final int minLines;
  final double maxListHeight;
  final bool obscureText;
  final void Function(String) onChanged;
  final void Function() onEditingComplete;
  final List<String> options;
  final void Function(String) onSubmitted;
  final void Function() onTap;
  final EdgeInsets padding;
  final ScrollController scrollController;
  final EdgeInsets scrollPadding;
  final ScrollPhysics scrollPhysics;
  final bool showCursor;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final TextCapitalization textCapitalization;
  final TextDirection textDirection;
  final TextInputAction textInputAction;
  final TextStyle textStyle;
  final EdgeInsets textPadding;
  final ToolbarOptions toolbarOptions;

  const DropdownText({Key key, this.autocorrect, this.autofocus, this.border, 
    this.borderColor, this.borderWidth, this.borderRadius, this.buildCounter, 
    this.caseSensitive, this.controller, this.cursorColor, this.cursorRadius, 
    this.cursorWidth, this.decoration, this.delay, this.delayTime, this.divider, 
    this.enabled, this.enableInteractiveSelection, this.enableSuggestions, 
    this.focusNode, this.icon, this.inputFormatters, this.item, this.itemBuilder, 
    this.itemRemover, this.keyboardAppearance, this.keyboardType, this.label, 
    this.labelText, this.listEnabled, this.maxLength, this.maxLengthEnforced, 
    this.maxLines, this.minLines, this.maxListHeight, this.obscureText, 
    this.onChanged, this.onEditingComplete, @required this.options, this.onSubmitted, 
    this.onTap, this.padding, this.scrollController, this.scrollPadding, 
    this.scrollPhysics, this.showCursor, this.strutStyle, this.textAlign, 
    this.textAlignVertical, this.textCapitalization, this.textDirection, 
    this.textInputAction, this.textStyle, this.textPadding, this.toolbarOptions}
    ) : super(key: key);

  @override
  _DropdownTextState createState() => _DropdownTextState();
}

class _DropdownTextState extends State<DropdownText> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  TextEditingController _controller;
  FocusNode _focusNode;
  bool divider;
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
  bool enabled;
  bool listEnabled;
  bool _show;
  String input = "";
  Widget item;
  Widget builder;
  Widget remover;

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
    enabled = widget.enabled ?? true;
    listEnabled = enabled? widget.listEnabled ?? true : false; 
    _show = false;
    divider = widget.divider ?? true;
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
        _show = listEnabled;
        _editList();
      }
      input = _controller.text;
    }
  }

  void focusListener(){
    if(_focusNode.hasFocus){
      _show = listEnabled;
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
        padding: widget.textPadding ?? EdgeInsets.fromLTRB(12.0, 4.0, 4.0, 0.0),
        child: TextField(
          style: widget.textStyle ?? _textStyle,
          focusNode: _focusNode,
          controller: _controller,
          decoration: widget.decoration ?? InputDecoration(
            border: InputBorder.none,
          ),
          buildCounter: widget.buildCounter,
          autocorrect: widget.autocorrect ?? false,
          autofocus: widget.autofocus ?? false,
          cursorColor: widget.cursorColor ?? Colors.black,
          cursorRadius: widget.cursorRadius,
          cursorWidth: widget.cursorWidth ?? 2.0,
          enableInteractiveSelection: widget.enableInteractiveSelection ?? true,
          enableSuggestions: widget.enableSuggestions ?? false,
          enabled: enabled,
          inputFormatters: widget.inputFormatters,
          keyboardAppearance: widget.keyboardAppearance,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          maxLength: widget.maxLength,
          maxLengthEnforced: widget.maxLengthEnforced ?? true,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          obscureText: widget.obscureText ?? false,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          scrollController: widget.scrollController,
          scrollPadding: widget.scrollPadding ?? EdgeInsets.all(20.0),
          scrollPhysics: widget.scrollPhysics,
          showCursor: widget.showCursor,
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign ?? TextAlign.start,
          textAlignVertical: widget.textAlignVertical,
          textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
          textDirection: widget.textDirection,
          textInputAction: widget.textInputAction,
          toolbarOptions: widget.toolbarOptions,
        ),
      ),
    );

  }

  Widget _label(){

    return label ? widget.labelText ?? Container(width: 0.0, height: 0.0,) : Container(width: 0.0, height: 0.0,);

  }

  Widget _button(){

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if(enabled){
          if(!_focusNode.hasFocus){
            _show = listEnabled? !_show : false;
            if(_listKey.currentState != null) _editList(text: "");
          }else{
            _show = false;
            if(_focusNode.hasFocus) _focusNode.unfocus();
          }
          setState(() {});
        }
      },
      child: widget.icon ?? Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          Icons.keyboard_arrow_down,
          color: iconColor,
          size: size,
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
          divider? Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 0.0),
            child: Divider(color: Colors.blueGrey[700],),
          ) : Container(width: 0.0, height: 0.0,),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.maxListHeight ?? 200, minHeight: 0.0),
            child: AnimatedList(
              key: _listKey,
              shrinkWrap: true,
              initialItemCount: list.length,
              itemBuilder: (context, index, animation) {
                return _buildAnimation(context, list[index], animation);
              },
            ),
          ),
        ],
      );
    }else return Container(width: 0.0, height: 0.0,);

  }

  Widget _removeAnimation(BuildContext context, String text, Animation<double> animation){

    if(widget.itemRemover != null) remover = widget.itemRemover(context, _itemCard(context, text), animation);
    else remover = _buildAnimation(context, text, animation);
    return remover;

  } 

  Widget _buildAnimation(BuildContext context, String text, Animation<double> animation){

    if(widget.itemBuilder != null) builder = widget.itemBuilder(context, _itemCard(context, text), animation);
    else builder = animationBuilder(context, text, animation, Curves.easeIn);
    return builder;

  }

  Widget animationBuilder(BuildContext context, String text, Animation<double> animation, Curve curve){
    return SlideTransition(
      position: animation.drive(
        Tween(
          begin: Offset(1, 0),
          end: Offset(0, 0),
        ).chain(CurveTween(curve: curve)),
      ),
      child: _itemCard(context, text),
    );
  }

  Widget _itemCard(BuildContext context, String text){
    if(widget.item != null) item = widget.item(context, text);
    else item = Card(
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
    );
    return GestureDetector(
      onTap: (){
        _show = false;
        setState(() {});
        if(_focusNode.hasFocus) _focusNode.unfocus();
        _controller.text = text;
      },
      child: item,
    );

  }

}