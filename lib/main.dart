// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/helpers/loading/loading_screen.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/bloc/authbloc.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/forgot_password_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowMaterialGrid: false,
    theme: ThemeData(
      primarySwatch: Colors.lightGreen,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const Homepage(),
    ),
    debugShowCheckedModeBanner: false,
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc,AuthState>(
      listener: (context, state) {
        if (state.isLoading){
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
            );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
      if (state is AuthStateLoggedIn){
        return const NotesView();
      }
      else if (state is AuthStateNeedsVerification){
        return const VerifiedEmailView();
      }
      else if (state is AuthStateLoggedOut){
        return const Loginview();
      }else if (state is AuthStateRegistering){
        return const Registerview();
      }else if (state is AuthStateForgotPassword){
        return const ForgotPassword();
      }
      else{
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    },
    ); 
    //  
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();

// }

// class _HomePageState extends State<HomePage> {

//   late final TextEditingController _controller;

//   @override void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }
//   @override void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => CounterBloc(),
//         child: Scaffold(
//           appBar: AppBar(
//           title: const Text('Testing bloc'),),
//           body: BlocConsumer<CounterBloc, CounterState>(
//             listener: (context, state) {
//               _controller.clear();
//             },
//             builder: (context, state) {
//               final invalidValue = (state is CounterStateInvalidNumber) ?
//               state.invalidValue : '';
//               return Column(
//                 children: [
//                  Text('Current value => ${state.value}'),
//                  Visibility(
//                   visible: state is CounterStateInvalidNumber,
//                   child: Text('invalid input: $invalidValue'),
//                   ),
//                   TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter a number here'
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   Row(
//                     children: [
//                      IconButton(
//                       onPressed: () {
//                         context
//                         .read<CounterBloc>()
//                         .add(DecrementEvent(_controller.text));
//                       },
//                       icon: const Icon(Icons.remove),
//                       ),
//                       IconButton(
//                       onPressed: () {
//                         context
//                         .read<CounterBloc>()
//                         .add(IncrementEvent(_controller.text));
//                       },
//                       icon: const Icon(Icons.add),
//                       )
//                     ],
//                   ) 
                 
//                 ],
//               );
//             },
//           )      
//       ),
//     );  
//   }
// }


// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid( int value) : super(value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInvalidNumber({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }


// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(String value) : super(value);
// }


// class DecrementEvent extends CounterEvent {
//   const DecrementEvent(String value) : super(value);
// }


// class CounterBloc extends Bloc<CounterEvent,CounterState> {
//   CounterBloc() : super(const CounterStateValid(0) ){ // it must have an initial state with is zero
//   on<IncrementEvent>((event, emit) {
//     final integer = int.tryParse(event.value);
//     if (integer == null){
//       emit(CounterStateInvalidNumber(
//         invalidValue: event.value,
//         previousValue: state.value,
//         )
//       );
//     }else{
//       emit(CounterStateValid(state.value +integer));
//     }
//   },);
//   on<DecrementEvent>((event, emit) {
//     final integer = int.tryParse(event.value);
//     if (integer == null){
//       emit(CounterStateInvalidNumber(
//         invalidValue: event.value,
//         previousValue: state.value,
//         )
//       );
//     }else{
//       emit(CounterStateValid(state.value - integer));
//     }
//   },
//   );
// }

// }


// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {

//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(

//         title: Text(widget.title),
//       ),
//       body: Center(
      
//         child: Column(
 
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }