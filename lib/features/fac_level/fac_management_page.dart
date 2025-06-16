import 'package:flight_sync_admin/core/constants/responses.dart';
import 'package:flight_sync_admin/core/widgets/add_item_dialog.dart';
import 'package:flight_sync_admin/core/widgets/confirmation_dialog.dart';
import 'package:flight_sync_admin/core/widgets/search_field.dart';
import 'package:flight_sync_admin/features/fac_level/bloc/fac_level_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flight_sync_admin/core/widgets/confirmation_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/web.dart';

class FACManagementPage extends StatefulWidget {
  const FACManagementPage({super.key});

  @override
  State<FACManagementPage> createState() => _FACManagementPageState();
}

class _FACManagementPageState extends State<FACManagementPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddDutyPositionDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        title: 'Add FAC Level',
        fields: [
          DialogFormField(
            label: 'Name',
            placeholder: 'Enter FAC level name',
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'FAC level name is required';
              }

              return null;
            },
          ),
        ],
        onSubmit: (values) {
          context.read<FacLevelBloc>().add(
                AddFacLevel(
                  facLevel: FacLevel(
                    level: values['Name']!,
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
            Row(
              children: [
                Expanded(
                  child: SearchField(
                    hintText: 'Search FAC levels...',
                    controller: _searchController,
                    onChanged: (value) {
                      debugPrint(value);
                      context.read<FacLevelBloc>().add(SearchFacLevel(value));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showAddDutyPositionDialog(context);
                      },
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Add FAC Level'),
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
                        minimumSize: const Size(40, 40),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            BlocConsumer<FacLevelBloc, FacLevelState>(
              listener: (context, state) {
                Logger().w({'state on ${state.facLevels}'});
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
                return state.facLevels == null
                    ? const SizedBox.shrink()
                    : state.facLevels!.isEmpty
                        ? const Center(
                            child: Text('No FAC levels found'),
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
                                              'Level',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                              width: 48), // For actions column
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: state.facLevels!.isEmpty
                                          ? const Center(
                                              child:
                                                  Text('No FAC levels found'),
                                            )
                                          : ListView.separated(
                                              padding: EdgeInsets.zero,
                                              itemCount:
                                                  state.facLevels!.length,
                                              separatorBuilder:
                                                  (context, index) => Divider(
                                                height: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                              ),
                                              itemBuilder: (context, index) {
                                                final fac =
                                                    state.facLevels![index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          fac.level!,
                                                          style:
                                                              const TextStyle(
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
                                                                  'Are you sure you want to delete ${fac.level}? This action cannot be undone.',
                                                              onConfirm: () {
                                                                context
                                                                    .read<
                                                                        FacLevelBloc>()
                                                                    .add(DeleteFacLevel(
                                                                        id: fac
                                                                            .id!));
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.delete_outline,
                                                          color:
                                                              Colors.red[400],
                                                          size: 20,
                                                        ),
                                                        padding:
                                                            EdgeInsets.zero,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  // TODO: Implement previous page
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
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
                                              TextButton(
                                                onPressed: () {
                                                  // TODO: Implement next page
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
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
