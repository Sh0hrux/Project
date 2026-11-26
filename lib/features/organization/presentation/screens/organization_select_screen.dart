import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_app/core/router/app_routes.dart';
import 'package:startup_app/core/widgets/empty_view.dart';
import 'package:startup_app/core/widgets/error_view.dart';
import 'package:startup_app/core/widgets/loading_indicator.dart';
import 'package:startup_app/features/organization/presentation/bloc/organization_bloc.dart';

class OrganizationSelectScreen extends StatefulWidget {
  const OrganizationSelectScreen({super.key});

  @override
  State<OrganizationSelectScreen> createState() =>
      _OrganizationSelectScreenState();
}

class _OrganizationSelectScreenState extends State<OrganizationSelectScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<OrganizationBloc>();
    if (bloc.state.organizations.isEmpty) {
      bloc.add(const LoadOrganizationsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tashkilotni tanlang'),
      ),
      body: BlocBuilder<OrganizationBloc, OrganizationState>(
        builder: (context, state) {
          if (state.status == OrganizationStatus.loading) {
            return const LoadingIndicator(
              message: 'Tashkilotlar yuklanmoqda...',
            );
          }

          if (state.status == OrganizationStatus.failure) {
            return ErrorView(
              message: state.errorMessage ?? 'Xatolik yuz berdi',
              onRetry: () => context
                  .read<OrganizationBloc>()
                  .add(const LoadOrganizationsEvent()),
            );
          }

          if (state.organizations.isEmpty) {
            return EmptyView(
              title: 'Tashkilotlar topilmadi',
              message: 'Sizda mavjud tashkilotlar yo\'q',
              actionText: 'Qayta yuklash',
              onAction: () => context
                  .read<OrganizationBloc>()
                  .add(const LoadOrganizationsEvent()),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.organizations.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final org = state.organizations[index];
              final isSelected = state.selectedOrganization?.id == org.id;

              return Card(
                child: ListTile(
                  key: Key('org_item_${org.id}'),
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.business_outlined,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(org.name),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: () {
                    context
                        .read<OrganizationBloc>()
                        .add(SelectOrganizationEvent(organization: org));
                    context.go(AppRoutes.home);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
