import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/app_colors.dart';
import '../../domain/product.dart';
import '../providers/product_provider.dart';

class UpdatePriceModal extends ConsumerStatefulWidget {
  final Product product;

  const UpdatePriceModal({super.key, required this.product});

  @override
  ConsumerState<UpdatePriceModal> createState() => _UpdatePriceModalState();
}

class _UpdatePriceModalState extends ConsumerState<UpdatePriceModal> {
  late TextEditingController _controller;
  bool _isLoading = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _savePrice() async {
    final value = double.tryParse(_controller.text);
    if (value == null || value <= 0) {
      setState(() => _errorText = 'El precio debe ser mayor a 0');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final repository = ref.read(productRepositoryProvider);
      await repository.updatePrice(widget.product.id, value);

      ref.refresh(productsListProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Precio actualizado correctamente!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = 'Error de conexión: No se pudo guardar.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: keyboardPadding + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Editar Precio',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Producto: ${widget.product.name}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'Nuevo Precio (BOB)',
              errorText: _errorText,
              prefixIcon: const Icon(
                Icons.attach_money,
                color: AppColors.secondary,
              ),
              suffixText: 'BOB',
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _savePrice,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('GUARDAR CAMBIOS'),
            ),
          ),
        ],
      ),
    );
  }
}
