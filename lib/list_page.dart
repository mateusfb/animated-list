import 'package:animated_list/components/animated_item.dart';
import 'package:animated_list/components/placeholder_widget.dart';
import 'package:animated_list/item_page.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with SingleTickerProviderStateMixin {
  int _selectedItemIndex = 0;

  late AnimationController _animationController;
  late Animation<Offset> _topMenuOffsetAnimation;
  late Animation<Offset> _filterBarOffsetAnimation;
  late Animation<Offset> _listOffsetAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _topMenuOffsetAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _filterBarOffsetAnimation = Tween<Offset>(
      begin: const Offset(2, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.3,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _listOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.3,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _topMenu(),
              const SizedBox(height: 10),
              _filterBar(),
              const SizedBox(height: 10),
              Expanded(
                child: _list(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topMenu() => SlideTransition(
        position: _topMenuOffsetAnimation,
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: PlaceholderWidget(
                color: Colors.grey.shade300,
                label: "Buscar",
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: PlaceholderWidget(
                color: Colors.grey.shade300,
                label: "Filtrar",
              ),
            ),
          ],
        ),
      );

  Widget _filterBar() => SlideTransition(
        position: _filterBarOffsetAnimation,
        child: SizedBox(
          height: 35,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: 10,
            separatorBuilder: (context, index) => const SizedBox(width: 5),
            itemBuilder: (context, index) {
              bool isSelected = index == _selectedItemIndex;

              return PlaceholderWidget(
                onTap: () {
                  setState(() {
                    _selectedItemIndex = index;
                  });
                },
                color: isSelected ? Colors.brown : Colors.white,
                border: Border.all(color: Colors.grey.shade800),
                label: "Item $index",
              );
            },
          ),
        ),
      );

  Widget _list() => SlideTransition(
        position: _listOffsetAnimation,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 4 / 5,
          children: List.generate(
            20,
            (index) => Hero(
              tag: index,
              child: AnimatedItem(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemPage(index: index),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
}
