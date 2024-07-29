// import 'package:flutter/material.dart';

// class ResultsScreen extends StatelessWidget {
//   final int totalQuestions;
//   final int correctAnswers;
//   final int wrongAttempts;

//   const ResultsScreen({
//     Key? key,
//     required this.totalQuestions,
//     required this.correctAnswers,
//     required this.wrongAttempts,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double successPercentage = (correctAnswers / totalQuestions) * 100;
//     double penalty = (wrongAttempts / totalQuestions) *
//         10; // Deduct percentage for each wrong attempt
//     double finalPercentage = successPercentage - penalty;

//     // Ensure the final percentage is not less than 0
//     finalPercentage = finalPercentage < 0 ? 0 : finalPercentage;

//     // Convert the final percentage to an integer
//     int finalPercentageInt = finalPercentage.round();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Level Results'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 const Text(
//                   'Results',
//                   style: TextStyle(
//                     fontSize: 28.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 Table(
//                   border: TableBorder.all(color: Colors.grey, width: 1.0),
//                   columnWidths: const {
//                     0: FlexColumnWidth(1.0),
//                     1: FlexColumnWidth(2.0),
//                   },
//                   children: [
//                     _buildTableRow('Item', 'Value', Colors.black,
//                         Colors.grey.shade300, true),
//                     _buildTableRow('Total Questions', '$totalQuestions',
//                         Colors.black, Colors.grey.shade100),
//                     _buildTableRow('Correct Answers', '$correctAnswers',
//                         Colors.green, Colors.grey.shade200),
//                     _buildTableRow('Wrong Attempts', '$wrongAttempts',
//                         Colors.red, Colors.grey.shade100),
//                     _buildTableRow(
//                         'Success Percentage',
//                         '$finalPercentageInt%',
//                         finalPercentageInt >= 50 ? Colors.green : Colors.red,
//                         Colors.grey.shade200),
//                   ],
//                 ),
//                 const SizedBox(height: 40.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context)
//                         .pop(); // Go back to the main screen or level
//                   },
//                   child: const Text('Back to Home Screen'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   TableRow _buildTableRow(
//       String label, String value, Color textColor, Color bgColor,
//       [bool isHeader = false]) {
//     return TableRow(
//       children: [
//         Container(
//           color: bgColor,
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: isHeader ? 18.0 : 16.0,
//               fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//               color: textColor,
//             ),
//           ),
//         ),
//         Container(
//           color: bgColor,
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: isHeader ? 18.0 : 16.0,
//               fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//               color: textColor,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAttempts;

  const ResultsScreen({
    Key? key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAttempts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int successPercentage = ((correctAnswers / totalQuestions) * 100).toInt();
    int penalty = ((wrongAttempts / totalQuestions) * 10).toInt();
    int finalPercentage = successPercentage - penalty;

    // Ensure final percentage is not less than 0
    finalPercentage = finalPercentage < 0 ? 0 : finalPercentage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Level Result'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: _buildResultRow(
                  'Total Questions', totalQuestions.toString(), Colors.blue),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: _buildResultRow(
                  'Correct Answers', correctAnswers.toString(), Colors.green),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: _buildResultRow(
                  'Wrong Attempts', wrongAttempts.toString(), Colors.red),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: _buildResultRow(
                'Success Percentage',
                '$finalPercentage%',
                finalPercentage >= 50 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back to Home Screen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
