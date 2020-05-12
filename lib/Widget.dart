import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final TextEditingController textController;
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
  final Duration insertItemDuration;
  final Widget Function(BuildContext, String) item;
  final Widget Function(BuildContext, Widget, Animation<double>) itemBuilder;
  final EdgeInsetsGeometry itemPadding;
  final Widget Function(BuildContext, Widget, Animation<double>) itemRemover;
  final Brightness keyboardAppearance;
  final TextInputType keyboardType;
  final bool label;
  final Text labelText;
  final bool listEnabled;
  final ScrollPhysics listPhysics;
  final bool listReverse;
  final ScrollController listScrollController;
  final Axis listScrollDirection;
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
  final EdgeInsetsGeometry padding;
  final Duration removeItemDuration;
  final ScrollController textScrollController;
  final EdgeInsetsGeometry textScrollPadding;
  final ScrollPhysics textScrollPhysics;
  final bool showCursor;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final TextCapitalization textCapitalization;
  final TextDirection textDirection;
  final TextInputAction textInputAction;
  final TextStyle textStyle;
  final EdgeInsetsGeometry textPadding;
  final ToolbarOptions toolbarOptions;

  const DropdownText({Key key, this.autocorrect, this.autofocus, this.border, 
  this.borderColor, this.borderWidth, this.borderRadius, this.buildCounter, 
  this.caseSensitive, this.textController, this.cursorColor, this.cursorRadius, 
  this.cursorWidth, this.decoration, this.delay, this.delayTime, this.divider, 
  this.enabled, this.enableInteractiveSelection, this.enableSuggestions, this.focusNode, 
  this.icon, this.inputFormatters, this.insertItemDuration, this.item, this.itemBuilder, 
  this.itemPadding, this.itemRemover, this.keyboardAppearance, this.keyboardType, this.label, 
  this.labelText, this.listEnabled, this.listPhysics, this.listReverse, this.listScrollController, 
  this.listScrollDirection, this.maxLength, this.maxLengthEnforced, this.maxLines, 
  this.minLines, this.maxListHeight, this.obscureText, this.onChanged, this.onEditingComplete, 
  @required this.options, this.onSubmitted, this.onTap, this.padding, this.removeItemDuration,
  this.textScrollController, this.textScrollPadding, this.textScrollPhysics, this.showCursor, 
  this.strutStyle, this.textAlign, this.textAlignVertical, this.textCapitalization, this.textDirection, 
  this.textInputAction, this.textStyle, this.textPadding, this.toolbarOptions, 
  }) : super(key: key);

  @override
  _DropdownTextState createState() => _DropdownTextState();
}

class _DropdownTextState extends State<DropdownText> {

  BorderStyle border = BorderStyle.none;
  Color borderColor = Colors.blueGrey;
  double borderRadius = 20.0;
  double borderWidth = 2.0;
  Widget builder;
  bool caseSensitive;
  bool delay;
  Duration delayTime;
  bool divider;
  bool enabled;
  FocusNode focusNode;
  String input = "";
  Widget item;
  List<String> list = [];
  ScrollController listScrollController;
  bool listEnabled;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<String> options;
  Duration removeItemDuration;
  Widget remover;
  bool show;
  double size = 25.0;
  TextEditingController textController;
  TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 25.0, );

  @override
  void initState() {
    super.initState();
    if (widget.textController != null) textController = widget.textController;
    else textController = TextEditingController();
    if (widget.focusNode != null) focusNode = widget.focusNode;
    else focusNode = FocusNode();
    options = widget.options;
    focusNode.addListener(focusListener);
    textController.addListener(controllerListener);
    caseSensitive = widget.caseSensitive ?? false;
    delay = widget.delay ?? true;
    delayTime = widget.delayTime ?? Duration(milliseconds: 100);
    enabled = widget.enabled ?? true;
    listEnabled = enabled? widget.listEnabled ?? true : false; 
    show = false;
    divider = widget.divider ?? true;
    if (widget.listScrollController != null) listScrollController = widget.listScrollController;
    else listScrollController = ScrollController();
    if(widget.removeItemDuration == null){
      if(widget.insertItemDuration != null) removeItemDuration = widget.insertItemDuration;
    }else removeItemDuration = widget.removeItemDuration;

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        label(),
        Expanded(
          child: Container(
            margin: widget.padding ?? EdgeInsets.only(left: 0.0),
            decoration: boxDecoration(), 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    textField(),
                    button(),
                  ],
                ),
                showList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }


  Widget animationBuilder(BuildContext context, String text, Animation<double> animation, Curve curve){
    return SlideTransition(
      position: animation.drive(
        Tween(
          begin: Offset(1, 0),
          end: Offset(0, 0),
        ).chain(CurveTween(curve: curve)),
      ),
      child: itemCard(context, text),
    );
  }

  BoxDecoration boxDecoration(){
    return BoxDecoration(
      border: Border.all(
        color: widget.borderColor ?? borderColor,
        style: widget.border ?? border,
        width: widget.borderWidth ?? borderWidth,
      ),
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? borderRadius))
    );
  }

  Widget buildAnimation(BuildContext context, String text, Animation<double> animation){
    if(widget.itemBuilder != null) builder = widget.itemBuilder(context, itemCard(context, text), animation);
    else builder = animationBuilder(context, text, animation, Curves.easeIn);
    return builder;
  }

  Widget button(){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if(enabled){
          if(!focusNode.hasFocus){
            show = listEnabled? !show : false;
            if(listKey.currentState != null) editList(text: "");
          }else{
            show = false;
            if(focusNode.hasFocus) focusNode.unfocus();
          }
          setState(() {});
        }
      },
      child: widget.icon ?? Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.blueGrey,
          size: size,
        ),
      ),
    );
  }

  void controllerListener(){
    if(focusNode.hasFocus){
      if(input.length != textController.text.length){
        show = listEnabled;
        editList();
      }
      input = textController.text;
    }
  }

  void editList({String text}){
    String _text = text ?? textController.text.trim() ?? "";
    bool rem = false;
    if(show){
      rem = removeItems(_text);
      if(!rem) insertItems(_text);
    }
  }

  void focusListener(){
    if(focusNode.hasFocus){
      show = listEnabled;
    }else show = false;
    setState(() {});
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
              if(widget.insertItemDuration != null){
                listKey.currentState.insertItem(
                  index++,
                  duration: widget.insertItemDuration,
                );
              }else listKey.currentState.insertItem(index++,);
            });
          });
        }else{
          list.add(options[i]);
          if(widget.insertItemDuration != null){
            listKey.currentState.insertItem(
              index++,
              duration: widget.insertItemDuration,
            );
          }else listKey.currentState.insertItem(index++,);
        }
      }
    }
  }

  Widget itemCard(BuildContext context, String text){
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
                style: widget.textStyle ?? textStyle,
              )
            ],
          ),
          Divider(color: Colors.blueGrey[700],),
        ],
      ),
    );
    return GestureDetector(
      onTap: (){
        show = false;
        setState(() {});
        if(focusNode.hasFocus) focusNode.unfocus();
        textController.text = text;
      },
      child: item,
    );
  }

  Widget label() => (widget.label ?? false)? (widget.labelText ?? Container(width: 0.0, height: 0.0,)) : Container(width: 0.0, height: 0.0,);

  Widget removeAnimation(BuildContext context, String text, Animation<double> animation){
    if(widget.itemRemover != null) remover = widget.itemRemover(context, itemCard(context, text), animation);
    else remover = buildAnimation(context, text, animation);
    return remover;
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
              if(removeItemDuration != null){
                listKey.currentState.removeItem(
                  i,
                  (BuildContext context, Animation<double> animation) => removeAnimation(context, deletedItem, animation),
                  duration: removeItemDuration,
                );
              }else{
                listKey.currentState.removeItem(
                  i,
                  (BuildContext context, Animation<double> animation) => removeAnimation(context, deletedItem, animation),
                );
              }
            });
          });
        }else{
          final String deletedItem = list.removeAt(i);
          if(removeItemDuration != null){
            listKey.currentState.removeItem(
              i,
              (BuildContext context, Animation<double> animation) => removeAnimation(context, deletedItem, animation),
              duration: removeItemDuration,
            );
          }else{
            listKey.currentState.removeItem(
              i,
              (BuildContext context, Animation<double> animation) => removeAnimation(context, deletedItem, animation),
            );
          }
        }
      }
    }
    return rem;
  }

  Widget showList(){
    if(show){
      if(list.length == 0) options.forEach((option){
        list.add(option);
      });
      if(textController.text.trim().isNotEmpty){
        for (int i =  list.length - 1; i >= 0; i--) {
          if(!(caseSensitive ? list[i].startsWith(textController.text.trim()) : list[i].toLowerCase().startsWith(textController.text.trim().toLowerCase()))){
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
              key: listKey,
              shrinkWrap: true,
              initialItemCount: list.length,
              itemBuilder: (context, index, animation) {
                  return buildAnimation(context, list[index], animation);
              },
              controller: listScrollController,
              padding: widget.itemPadding,
              physics: widget.listPhysics,
              reverse: widget.listReverse ?? false,
              scrollDirection: widget.listScrollDirection ?? Axis.vertical,
            ),
          ),
        ],
      );
    }else return Container(width: 0.0, height: 0.0,);
  }

  Widget textField(){
    return Expanded(
      child: Padding(
        padding: widget.textPadding ?? EdgeInsets.fromLTRB(12.0, 4.0, 4.0, 0.0),
        child: TextField(
          style: widget.textStyle ?? textStyle,
          focusNode: focusNode,
          controller: textController,
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
          scrollController: widget.textScrollController,
          scrollPadding: widget.textScrollPadding ?? EdgeInsets.all(20.0),
          scrollPhysics: widget.textScrollPhysics,
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

}