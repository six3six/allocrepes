import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:allocrepes/lobby/cubit/lobby_cubit.dart';
import 'package:allocrepes/lobby/view/lobby_menu_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LobbyTop extends StatelessWidget {
  static final pointRoundSize = 37.0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = BlocProvider.of<AuthenticationBloc>(context).state.user;

    final bubbleColor = Theme.of(context).primaryColorDark;

    final borderRadius = BorderRadius.all(Radius.circular(50));

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 40),
                child: Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Xanthos',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: InkWell(
                    onTap: () {
                      showDialog(context: context, builder: (context) {
                        return LobbyMenuPopup();
                      });
                    },
                    borderRadius: borderRadius,
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 10, right: 41 - pointRoundSize),
                      height: 45,
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        border: Border.all(color: bubbleColor),
                        borderRadius: borderRadius,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 90,
                            ),
                            child: Text(
                              user.surname,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.all(3),
                            width: pointRoundSize,
                            height: pointRoundSize,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: bubbleColor,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(pointRoundSize),
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                user.point.toString(),
                                style: TextStyle(
                                  color: bubbleColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
