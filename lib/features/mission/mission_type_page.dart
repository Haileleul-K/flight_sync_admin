import 'package:flight_sync_admin/core/constants/responses.dart';
import 'package:flight_sync_admin/core/widgets/add_item_dialog.dart';
import 'package:flight_sync_admin/core/widgets/confirmation_dialog.dart';
import 'package:flight_sync_admin/core/widgets/search_field.dart';
import 'package:flight_sync_admin/features/mission/bloc/mission_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MissionTypePage extends StatefulWidget {
  const MissionTypePage({super.key});

  @override
  State<MissionTypePage> createState() => _MissionTypePageState();
}

class _MissionTypePageState extends State<MissionTypePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddDutyPositionDialog(BuildContext context) {
    final codeController = TextEditingController();
    final labelController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        title: 'Add Mission Type',
        fields: [
          DialogFormField(
            label: 'Code',
            placeholder: 'Enter mission type code',
            controller: codeController,
          ),
          DialogFormField(
            label: 'Label',
            placeholder: 'Enter mission type label',
            controller: labelController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Label is required';
              }

              return null;
            },
          ),
        ],
        onSubmit: (values) {
          context.read<MissionBloc>().add(
                AddMission(
                  mission: Mission(
                    code: values['Code']!,
                    label: values['Label']!,
                  ),
                ),
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 600;
                return Row(
                  children: [
                    Expanded(
                      child: SearchField(
                        hintText: 'Search mission types...',
                        controller: _searchController,
                        onChanged: (value) {
                          context.read<MissionBloc>().add(SearchMission(value));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (!isSmallScreen)
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showAddDutyPositionDialog(context);
                            },
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Add Mission Type'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C5DD3),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size.fromHeight(40),
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            _showAddDutyPositionDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C5DD3),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(40, 40),
                          ),
                          child: const Icon(Icons.add, size: 20),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            BlocConsumer<MissionBloc, MissionState>(
              listener: (context, state) {
                if (state.message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message!)),
                  );
                }
                if (state.isLoading == true) {
                  EasyLoading.show();
                } else {
                  EasyLoading.dismiss();
                }
              },
              builder: (context, state) {
                return state.missions == null
                    ? const SizedBox.shrink()
                    : state.missions!.isEmpty
                        ? const Center(
                            child: Text('No mission types found'),
                          )
                        : Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Code',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'Label',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 48),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemCount: state.missions!.length,
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                          height: 1,
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                        itemBuilder: (context, index) {
                                          final missionType =
                                              state.missions![index];
                                          return Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    missionType.code!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    missionType.label!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          ConfirmationDialog(
                                                        message:
                                                            'Are you sure you want to delete ${missionType.code}?',
                                                        onConfirm: () {
                                                          context
                                                              .read<
                                                                  MissionBloc>()
                                                              .add(DeleteMission(
                                                                  id: missionType
                                                                      .id!));
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red[400],
                                                    size: 20,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              // TODO: Implement previous page
                                            },
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                            ),
                                            child: Text(
                                              'Previous',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF6C5DD3),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              '1',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton(
                                            onPressed: () {
                                              // TODO: Implement next page
                                            },
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                            ),
                                            child: Text(
                                              'Next',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
