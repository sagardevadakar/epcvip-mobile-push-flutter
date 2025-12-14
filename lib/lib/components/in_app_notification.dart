import 'package:flutter/material.dart';

class InAppNotification extends StatefulWidget {
  final String title;
  final String body;
  final String? image;
  final VoidCallback? onPress;
  final VoidCallback onHide;

  const InAppNotification({
    required this.title,
    required this.body,
    this.image,
    this.onPress,
    required this.onHide,
  });

  @override
  State<InAppNotification> createState() => _InAppNotificationState();
}

class _InAppNotificationState extends State<InAppNotification> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0)).animate(_controller);
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    Future.delayed(Duration(seconds: 4), () => _hide());
  }

  void _hide() {
    _controller.reverse().then((value) => widget.onHide());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: GestureDetector(
          onTap: widget.onPress,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
              ],
              border: Border.all(color: Colors.white70),
            ),
            child: Row(
              children: [
                widget.image != null
                    ? Image.network(widget.image!, width: 55, height: 55, fit: BoxFit.cover)
                    : Container(width: 55, height: 55, color: Colors.grey[300]),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(widget.body, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _hide,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    child: Text('×', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
