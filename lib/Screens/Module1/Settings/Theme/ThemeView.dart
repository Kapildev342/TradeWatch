import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/ThemeBloc/theme_bloc.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';

class ThemeView extends StatefulWidget {
  const ThemeView({super.key});

  @override
  State<ThemeView> createState() => _ThemeViewState();
}

class _ThemeViewState extends State<ThemeView> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text(
            "Theme settings",
            /*style: TextStyle(
              fontSize: text.scale(16),
              fontWeight: FontWeight.w600,
            ),*/
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
            ),
          ),
        ),
        body: BlocProvider(
          create: (context) => ThemeBloc()..add(ThemeInitialEvent(value: currentTheme.value == ThemeMode.dark)),
          child: BlocBuilder<ThemeBloc, ThemeState>(builder: (BuildContext context, ThemeState theme) {
            if (theme is ThemeLoaded) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.light_mode,
                        size: 35,
                      ),
                      ActionSlider.standard(
                        sliderBehavior: SliderBehavior.stretch,
                        width: width / 1.5,
                        backgroundColor: Theme.of(context).colorScheme.background,
                        toggleColor: isDarkTheme.value ? const Color(0XFFFFFFFF) : const Color(0XFF0EA102),
                        action: (controller) async {
                          controller.loading(); //starts loading animation
                          await Future.delayed(const Duration(seconds: 1));
                          controller.success(); //starts success animation
                          await Future.delayed(const Duration(seconds: 1), () {
                            context.read<ThemeBloc>().add(ThemeChangingEvent(value: !isDarkTheme.value));
                          });
                          controller.reset(); //resets the slider
                        },
                        direction: isDarkTheme.value ? TextDirection.rtl : TextDirection.ltr,
                        backgroundBorderRadius: BorderRadius.circular(100),
                        icon: Icon(
                          isDarkTheme.value ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        loadingIcon: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.background,
                        ),
                        successIcon: Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        boxShadow: [
                          isDarkTheme.value
                              ? const BoxShadow(
                                  color: Colors.white30,
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                )
                              : const BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                )
                        ],
                        child: Text(isDarkTheme.value ? 'Slide to dark theme   ' : '   Slide to light theme'),
                      ),
                      const Icon(
                        Icons.dark_mode,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              );
            } else if (theme is ThemeLoading) {
              return const SizedBox();
            } else {
              return const SizedBox();
            }
          }),
        ),
      ),
    );
  }
}
