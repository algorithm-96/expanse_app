import 'package:expanses_app/models/expense_model.dart';
import 'package:expanses_app/widgets/chart/chart.dart';
import 'package:expanses_app/widgets/expense_list/expenses_list.dart';
import 'package:expanses_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  final List<ExpenseModel> _registeredExpense = [];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
              onAddExpense: _addExpense,
            ));
  }

  void _addExpense(ExpenseModel expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }

  void _removeExpense(ExpenseModel expense) {
    final expenseIndex = _registeredExpense.indexOf(expense);
    setState(() {
      _registeredExpense.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpense.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('OJAN KONTOL'),
    );

    if (_registeredExpense.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: _registeredExpense,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Flutter Expenses App'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpense),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
