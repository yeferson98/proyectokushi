import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<NetworkImage> images;

  const Carousel({Key key, this.images}) : super(key: key);

  @override
  State createState() => CarouselState();
}

class CarouselState extends State<Carousel> {
  PageController _controller = PageController();
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.images.length; i++) {
      list.add(
        i == _currentPage
            ? dotIndicator(isActive: true, index: i)
            : dotIndicator(isActive: false, index: i),
      );
    }
    return list;
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  switchToPage(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageView = PageView(
      physics: AlwaysScrollableScrollPhysics(),
      onPageChanged: (int page) {
        setState(() {
          _currentPage = page;
        });
      },
      controller: _controller,
      children: widget.images.map((image) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: image,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      }).toList(),
    );

    final indicators = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildPageIndicator(),
    );

    final bottom = Container(
      height: 10.0,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: indicators,
    );

    return Column(
      children: <Widget>[
        Expanded(child: pageView),
        bottom,
        SizedBox(
          height: 39,
        ),
      ],
    );
  }

  dotIndicator({bool isActive, int index}) {
    double size = 10.0;
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: InkWell(
        onTap: () => switchToPage(index),
      ),
    );
  }
}
