import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final dialogWidth =
        isDesktop ? 400.0 : MediaQuery.of(context).size.width * 0.9;
    final buttonHeight = isDesktop ? 40.0 : 48.0;
    final horizontalPadding = isDesktop ? 24.0 : 16.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: dialogWidth,
          margin: EdgeInsets.symmetric(
            vertical: isDesktop ? 24.0 : 16.0,
            horizontal: 0,
          ),
          padding: EdgeInsets.all(horizontalPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: Colors.red.shade400,
                  size: 28,
                ),
              ),
              SizedBox(height: isDesktop ? 16 : 12),
              Text(
                'Are you sure?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 20 : 18,
                    ),
              ),
              SizedBox(height: isDesktop ? 8 : 6),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: isDesktop ? 14 : 16,
                      ),
                ),
              ),
              SizedBox(height: isDesktop ? 24 : 20),
              Container(
                padding: EdgeInsets.only(top: horizontalPadding),
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
                                onConfirm();
                                Navigator.of(context).pop();
                              },
                              style: _buttonStyle(context,
                                  isOutlined: false, isDesktop: isDesktop),
                              child: Text(
                                'Confirm',
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
                                  onConfirm();
                                  Navigator.of(context).pop();
                                },
                                style: _buttonStyle(context,
                                    isOutlined: false, isDesktop: isDesktop),
                                child: Text(
                                  'Confirm',
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
      backgroundColor: Colors.red.shade400,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
