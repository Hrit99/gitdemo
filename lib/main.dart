import 'package:flutter/material.dart';
import 'package:fluttertasks/commit.dart';
import 'package:fluttertasks/repo.dart';
import 'package:fluttertasks/tile.dart';
import 'package:fluttertasks/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';
import 'package:semaphore/semaphore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gitdemo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gitdemo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<Repo> responseData = [];
  late SlidableController controller1;
  late SlidableController controller2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1 = SlidableController(this);
    controller2 = SlidableController(this);
    fetchDataFromApi().then((_) {
      getLastCommits(responseData);
    });
  }

  Future<void> fetchDataFromApi() async {
    try {
      print("herep");
      final response = await http
          .get(Uri.parse('https://api.github.com/users/freeCodeCamp/repos'));
      if (response.statusCode == 200) {
        print("here");
        setState(() {
          for (var repojson in json.decode(response.body)) {
            Repo repo = Repo.fromJson(repojson);
            repo.lastCommit = ValueNotifier<Commit>(
                Commit(message: "", sha: null, author: null, committer: null));
            responseData.add(repo);
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void opencloseTile() {
    controller1.openStartActionPane();
    Future.delayed(Duration(seconds: 2)).then((value) {
      controller1.close();
      Future.delayed(Duration(seconds: 1)).then((value) {
        controller2.openStartActionPane();
        Future.delayed(Duration(seconds: 2)).then((value) {
          controller2.close();
          Future.delayed(Duration(seconds: 1)).then((value) {
            controller2.openEndActionPane();
            Future.delayed(Duration(seconds: 2)).then((value) {
              controller2.close();
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2)).then((value) {
      opencloseTile();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Gitdemo'),
      ),
      body: Center(
        child: responseData.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (context, index) => Container(
                  color: Colors.grey,
                  height: 2.0,
                ),
                itemCount: responseData.length,
                itemBuilder: (context, index) {
                  return Tile(
                      index: index,
                      repo: responseData[index],
                      controller: index == 0
                          ? controller1
                          : (index == 1 ? controller2 : null));
                },
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

Future<void> getLastCommits(List<Repo> repos) async {
  final semaphore = LocalSemaphore(10);

  final List<Future> futures = [];

  for (int i = 0; i < repos.length; i++) {
    futures.add(semaphore.acquire().then((_) async {
      try {
        final response = await http.get(Uri.parse(
            'https://api.github.com/repos/freeCodeCamp/${repos[i].name}/commits')); // Your API endpoint
        if (response.statusCode == 200) {
          User author =
              User.fromJson(json.decode(response.body)[0]['commit']['author']);
          User committer = User.fromJson(
              json.decode(response.body)[0]['commit']['committer']);

          Commit lastCommit = Commit(
              message: json.decode(response.body)[0]['commit']['message'],
              sha: json.decode(response.body)[0]['sha'],
              author: author,
              committer: committer);
          repos[i].lastCommit!.value = lastCommit;
        } else {
          print('Request $i failed: ${response.statusCode}');
        }
      } catch (e) {
        print('Request $i failed: $e');
      } finally {
        semaphore.release();
      }
    }));
  }

  await Future.wait(futures);
  print("got all commits");
}
