import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../domain/entities/expense.dart';
import '../services/expense_service.dart';
import '../theme/app_colors.dart';
import '../utils/category_utils.dart';
import '../utils/formatters.dart';
import '../widgets/glass_card.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.card,
            onSurface: AppColors.textPrimary,
          ),
          dialogTheme: const DialogThemeData(
            backgroundColor: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final rawAmount = _amountController.text
        .replaceAll('.', '')
        .replaceAll(',', '.');
    final amount = double.tryParse(rawAmount);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Valor inválido')));
      return;
    }

    setState(() => _isLoading = true);

    await context.read<ExpenseService>().addExpense(
      title: _titleController.text.trim(),
      amount: amount,
      date: _selectedDate,
      category: _selectedCategory,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    if (mounted) {
      HapticFeedback.lightImpact();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nova Despesa'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  _buildAmountCard(),
                  const SizedBox(height: 14),
                  _buildTitleField(),
                  const SizedBox(height: 14),
                  _buildCategorySelector(),
                  const SizedBox(height: 14),
                  _buildDatePicker(),
                  const SizedBox(height: 14),
                  _buildNoteField(),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                  const SizedBox(height: 48),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Amount Card ───────────────────────────────────────────────────────────

  Widget _buildAmountCard() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      borderColor: AppColors.primary.withValues(alpha: 0.35),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.1),
          blurRadius: 30,
          offset: const Offset(0, 8),
        ),
      ],
      child: Column(
        children: [
          const Text(
            'VALOR',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                'R\$',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: TextFormField(
                  controller: _amountController,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0,00',
                    hintStyle: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 44,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe o valor';
                    final d = double.tryParse(
                      v.replaceAll('.', '').replaceAll(',', '.'),
                    );
                    if (d == null || d <= 0) return 'Valor inválido';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0);
  }

  // ── Title Field ───────────────────────────────────────────────────────────

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      style: const TextStyle(color: AppColors.textPrimary),
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Descrição',
        prefixIcon: Icon(Icons.edit_rounded),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Informe uma descrição';
        return null;
      },
    ).animate(delay: 40.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  // ── Category Selector ─────────────────────────────────────────────────────

  Widget _buildCategorySelector() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CATEGORIA',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ExpenseCategory.values.map((cat) {
              final selected = _selectedCategory == cat;
              final color = CategoryUtils.color(cat);
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedCategory = cat);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? color.withValues(alpha: 0.18)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? color : AppColors.cardBorder,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CategoryUtils.icon(cat),
                        color: selected ? color : AppColors.textMuted,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        CategoryUtils.label(cat),
                        style: TextStyle(
                          color: selected ? color : AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate(delay: 80.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  // ── Date Picker ───────────────────────────────────────────────────────────

  Widget _buildDatePicker() {
    return GlassCard(
          onTap: _selectDate,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DATA',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Formatters.date(_selectedDate),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        )
        .animate(delay: 120.ms)
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0);
  }

  // ── Note Field ────────────────────────────────────────────────────────────

  Widget _buildNoteField() {
    return TextFormField(
          controller: _noteController,
          style: const TextStyle(color: AppColors.textPrimary),
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Nota (opcional)',
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 22),
              child: Icon(Icons.notes_rounded),
            ),
            alignLabelWithHint: true,
          ),
        )
        .animate(delay: 160.ms)
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0);
  }

  // ── Submit Button ─────────────────────────────────────────────────────────

  Widget _buildSubmitButton() {
    return GestureDetector(
          onTap: _isLoading ? null : _submit,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 56,
            decoration: BoxDecoration(
              gradient: _isLoading
                  ? const LinearGradient(
                      colors: [Color(0xFF1A2340), Color(0xFF1A2340)],
                    )
                  : AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isLoading
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.38),
                        blurRadius: 24,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Salvar Despesa',
                      style: TextStyle(
                        color: AppColors.background,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        )
        .animate(delay: 200.ms)
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.15, end: 0);
  }
}
