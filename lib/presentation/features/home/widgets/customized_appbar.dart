import 'package:flutter/material.dart';

class CustomizedAppBar extends PreferredSize {
  @override
  Size get preferredSize => Size.fromHeight(70);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Text(
                  'Perminda',
                  style: TextStyle(color: Colors.black, fontSize: 17.0),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0, left: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                        hintText: 'What are you looking for...',
                        hintStyle: TextStyle(fontSize: 13),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
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
