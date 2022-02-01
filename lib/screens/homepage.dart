import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insta_details/models/data.dart';
import 'package:insta_details/utils/custom_dio_mixin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static String id = "HomePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with CustomDioMixin {
  bool loading = true;
  bool error = false;
  List<Media> media = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : error
                    ? const Center(
                        child: Text('An error has occurred!'),
                      )
                    : ListView.builder(
                        itemCount: 6,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // print("media n° $index ${media[index].mediaUrl}");
                          // return media != null && media[index].mediaUrl != ""
                          //     ? Image.network(media[index].mediaUrl)
                          //     : SizedBox.shrink();
                          return media[index].mediaUrl != ""
                              ? Stack( 
                                  children: [
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 100,
                                        ),
                                        Card(
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(32.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.network(
                                                    media[index].mediaUrl),
                                                Text(
                                                  "the caption: ${media[index].caption}",
                                                  style: const TextStyle(
                                                    fontSize: 35,
                                                    color: Color(0xFF414C6B),
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Text(
                                                  "media ID ${media[index].id}",
                                                  style: const TextStyle(
                                                    fontSize: 23,
                                                    color: Color(0xFF414C6B),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                const SizedBox(
                                                  height: 32,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      media[index].timestamp,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xFFE4979E),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    const Icon(
                                                      Icons.timer,
                                                      color: Color(0xFFE4979E),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink();
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> getData() async {
    try {
      final storage = GetStorage();

      final token = storage.read("accessToken");

      final response = await dio.get(
        'https://graph.instagram.com/me/media?fields=id,caption,media_url,timestamp&access_token=$token',
      );
      print("get data response => ${response.statusCode} ${response.data}");
      if (response.statusCode.toString().startsWith('2')) {
        media = Medias.fromMap(response.data).data;
      }
    } catch (e) {
      print("get data failed");
      print(e);
      setState(() {
        error = true;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
