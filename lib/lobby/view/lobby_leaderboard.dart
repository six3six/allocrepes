import 'package:allocrepes/lobby/cubit/lobby_cubit.dart';
import 'package:allocrepes/lobby/cubit/lobby_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LobbyLeaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<LobbyCubit, LobbyState>(
        buildWhen: (prev, next) => prev.showCls != next.showCls,
        builder: (context, state) {
          return state.showCls ? _LobbyLeaderboardView() : SizedBox();
        },
      ),
    );
  }
}

class _LobbyLeaderboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    var i = 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: BlocBuilder<LobbyCubit, LobbyState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Classement des meilleurs athlètes',
                style: textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              ...state.leaderboard
                  .map((e) => _LobbyLeaderboardTile(
                        player: e,
                        ranking: i++,
                      ))
                  .toList()
            ],
          );
        },
      ),
    );
  }
}

class _LobbyLeaderboardTile extends StatelessWidget {
  final String player;
  final int ranking;

  const _LobbyLeaderboardTile({
    super.key,
    required this.player,
    required this.ranking,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(Radius.circular(50));
    final bubbleColor = Theme.of(context).primaryColorDark;

    return Container(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 2),
        height: 35,
        decoration: BoxDecoration(
          color: bubbleColor,
          border: Border.all(color: bubbleColor),
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            (ranking <= 3)
                ? Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(
                      (ranking == 1)
                          ? FontAwesomeIcons.trophy
                          : FontAwesomeIcons.medal,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                : Text(
                    '$ranking. ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
            Text(
              player,
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
