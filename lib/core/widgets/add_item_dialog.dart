import 'package:flutter/material.dart';

class DialogFormField {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  DialogFormField({
    required this.label,
    required this.placeholder,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
  });
}

class AddItemDialog extends StatefulWidget {
  final String title;
  final List<DialogFormField> fields;
  final Function(Map<String, String>) onSubmit;
  final Widget? customContent;

  const AddItemDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
    this.customContent,
  });

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final dialogWidth =
        isDesktop ? 500.0 : MediaQuery.of(context).size.width * 0.9;
    final dialogPadding = isDesktop ? 24.0 : 16.0;
    final fieldPadding = isDesktop ? 16.0 : 12.0;
    final buttonHeight = isDesktop ? 40.0 : 48.0;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.9,
          ),
          margin: EdgeInsets.symmetric(
            vertical: isDesktop ? 24.0 : 16.0,
            horizontal: 0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(dialogPadding),
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 24 : 20,
                      ),
                ),
              ),
              Flexible(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: dialogPadding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...widget.fields.map((field) => Padding(
                                  padding:
                                      EdgeInsets.only(bottom: fieldPadding),
                                  child: TextFormField(
                                    controller: field.controller,
                                    validator: field.validator ??
                                        (value) {
                                          if (value == null || value.isEmpty) {
                                            return '${field.label} is required';
                                          }
                                          return null;
                                        },
                                    keyboardType: field.keyboardType,
                                    style: TextStyle(
                                      fontSize: isDesktop ? 14 : 16,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: field.label,
                                      labelStyle: TextStyle(
                                        fontSize: isDesktop ? 14 : 16,
                                      ),
                                      hintText: field.placeholder,
                                      hintStyle: TextStyle(
                                        fontSize: isDesktop ? 14 : 16,
                                        color: Colors.grey[500],
                                      ),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Colors.red.shade400,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Colors.red.shade400,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: isDesktop ? 12 : 16,
                                        vertical: isDesktop ? 8 : 12,
                                      ),
                                    ),
                                  ),
                                )),
                            if (widget.customContent != null) ...[
                              const SizedBox(height: 8),
                              widget.customContent!,
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(dialogPadding),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
                child: MediaQuery.of(context).size.width < 350
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: buttonHeight,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: _buttonStyle(context,
                                  isOutlined: true, isDesktop: isDesktop),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: isDesktop ? 14 : 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final values = {
                                    for (var field in widget.fields)
                                      field.label: field.controller.text
                                  };
                                  widget.onSubmit(values);
                                  Navigator.of(context).pop();
                                }
                              },
                              style: _buttonStyle(context,
                                  isOutlined: false, isDesktop: isDesktop),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: isDesktop ? 14 : 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: buttonHeight,
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: _buttonStyle(context,
                                    isOutlined: true, isDesktop: isDesktop),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: isDesktop ? 14 : 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: isDesktop ? 16 : 12),
                          Expanded(
                            child: SizedBox(
                              height: buttonHeight,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final values = {
                                      for (var field in widget.fields)
                                        field.label: field.controller.text
                                    };
                                    widget.onSubmit(values);
                                    Navigator.of(context).pop();
                                  }
                                },
                                style: _buttonStyle(context,
                                    isOutlined: false, isDesktop: isDesktop),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: isDesktop ? 14 : 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context,
      {required bool isOutlined, required bool isDesktop}) {
    if (isOutlined) {
      return OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 24 : 16,
        ),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6C5DD3),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  void dispose() {
    for (var field in widget.fields) {
      field.controller.dispose();
    }
    super.dispose();
  }
}
