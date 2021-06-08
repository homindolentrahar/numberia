import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:numberia/core/common/animations/fade_animation.dart';
import 'package:numberia/core/common/themes/color_palette.dart';
import 'package:numberia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numberia/features/number_trivia/presentation/bloc/number_trivia_cubit.dart';
import 'package:numberia/features/number_trivia/presentation/widgets/rounded_text_field.dart';
import 'package:numberia/injection_container.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final NumberTriviaCubit _cubit = locator.get<NumberTriviaCubit>();
  final TextEditingController _numberController = TextEditingController();

  Widget _buildBackground() {
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          ColorPalette.black,
          ColorPalette.dark.withAlpha(244),
        ],
      ).createShader(rect),
      child: Image.asset(
        "assets/images/bg.png",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<NumberTriviaCubit, NumberTriviaState>(
          bloc: _cubit,
          buildWhen: (previous, current) => previous != current,
          builder: (ctx, state) {
            if (state is Empty) {
              return _buildHeader();
            } else if (state is Loading) {
              return _buildLoading();
            } else if (state is Loaded) {
              return _buildTriviaResult(state.trivia);
            } else if (state is Error) {
              return _buildError(state.message);
            } else {
              return _buildHeader();
            }
          },
        ),
        SizedBox(height: 30),
        FadeAnimation(
          delay: 1.3,
          direction: FadeAnimationDirections.DOWN,
          child: Column(
            children: [
              RoundedTextField(
                controller: _numberController,
                hint: "input your number",
                onChanged: (value) {},
              ),
              SizedBox(height: 30),
              _buildTriviaButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return SpinKitFadingFour(
      color: ColorPalette.light,
      size: 48,
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "numberia",
          style: GoogleFonts.comfortaa(
            color: ColorPalette.white,
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "provide trivia for the numbers",
          style: GoogleFonts.firaCode(
            color: ColorPalette.light,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTriviaResult(NumberTrivia trivia) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trivia.number.toString(),
            style: GoogleFonts.comfortaa(
              color: ColorPalette.white,
              fontSize: 36,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            child: SingleChildScrollView(
              child: Text(
                trivia.text,
                textAlign: TextAlign.center,
                style: GoogleFonts.firaCode(
                  color: ColorPalette.light,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Error occurred!",
          style: GoogleFonts.comfortaa(
            color: ColorPalette.white,
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.1,
          child: SingleChildScrollView(
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.firaCode(
                color: ColorPalette.light,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTriviaButton() {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      height: 56,
      color: ColorPalette.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Ionicons.language_outline,
            size: 28,
            color: ColorPalette.white,
          ),
          SizedBox(width: 10),
          Text(
            "trivia",
            style: GoogleFonts.firaCode(
              color: ColorPalette.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      onPressed: () {
        _cubit.getTriviaForConcreteNumber(_numberController.text.toString());
        _numberController.clear();
      },
    );
  }

  Widget _buildRandomButton() {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      height: 56,
      color: ColorPalette.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Ionicons.dice_outline,
            size: 28,
            color: ColorPalette.dark,
          ),
          SizedBox(width: 10),
          Text(
            "randomize",
            style: GoogleFonts.firaCode(
              color: ColorPalette.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      onPressed: () => _cubit.getTriviaForRandomNumber(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (ctx) => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _buildBackground(),
              _buildContent(),
              FadeAnimation(
                delay: 1.6,
                direction: FadeAnimationDirections.UP,
                child: _buildRandomButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
