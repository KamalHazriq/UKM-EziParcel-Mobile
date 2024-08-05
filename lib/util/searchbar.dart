import 'package:flutter/material.dart';

class CSearchBar extends StatefulWidget {
  final Function(String) onSubmitted; 

  const CSearchBar({
    Key? key,
    required this.onSubmitted, 
  }) : super(key: key);

  @override
  _CSearchBarState createState() => _CSearchBarState();
}

class _CSearchBarState extends State<CSearchBar> {
  final TextEditingController _controller = TextEditingController();
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 330, 
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'No Pengesanan',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchText = _controller.text;
                    });
                    widget.onSubmitted(_searchText); 
                  },
                ),
              ),
              onSubmitted: widget.onSubmitted, 
            ),
          ),
        ),
        
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
