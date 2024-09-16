import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_conn.dart';
import 'package:rootnode/model/conn.dart';
import 'package:rootnode/repository/conn_repo.dart';
import 'package:rootnode/widgets/live_messenger_stats.dart';
import 'package:rootnode/widgets/messenger_card.dart';
import 'package:rootnode/widgets/such_empty.dart';

class MessengerScreen extends ConsumerStatefulWidget {
  const MessengerScreen({super.key});

  @override
  ConsumerState<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends ConsumerState<MessengerScreen> {
  late final ScrollController _scrollController;
  List<Connection> conns = [];
  int currentPage = 1;

  _getInitialConns() async {
    final connRepo = ref.read(connRepoProvider);
    currentPage = 1;
    MyConnsResponse? res =
        await connRepo.getMyConns(page: currentPage, refresh: 1);
    if (res != null) {
      currentPage++;
      conns.clear();
      conns.addAll(res.conns!);
      conns = conns.reversed.toList();
    }
    _smartSetState();
  }

  _fetchMoreData() {
    debugPrint("Fetch");
    _smartSetState();
  }

  _smartSetState() {
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => mounted ? setState(() {}) : null);
  }

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
          _fetchMoreData();
        }
      });
    _getInitialConns();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return conns.isEmpty
        ? const SuchEmpty()
        : ListView.builder(
            itemBuilder: (context, index) => index == 0
                ? const RNLiveMessage()
                : MessengerCard(
                    node: conns[index].node!,
                  ),
            itemCount: conns.length,
          );
  }
}
          // ,
