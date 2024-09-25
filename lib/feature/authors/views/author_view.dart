import 'package:ballsquad_project/product/base/constants/app_constants.dart';

import '../../../exports.dart';

final class AuthorsView extends StatefulWidget {
  const AuthorsView({super.key});
  @override
  State<AuthorsView> createState() => _AuthorsViewState();
}

final class _AuthorsViewState extends State<AuthorsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authors'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onSubmitted: (value) {
                if (value.isEmpty) return;
                context.read<AuthorsCubit>().getAuthors(value);
              },
              decoration: InputDecoration(
                hintText: 'Search for authors',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            Flexible(
              child: BlocConsumer<AuthorsCubit, AuthorsState>(
                listener: (context, state) {
                  if (state is AuthorsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthorsInitial) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.asset(
                            fit: BoxFit.cover,
                            'assets/gif/author_homepage.gif',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          textAlign: TextAlign.center,
                          AppConstants.initialPageMessage,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ],
                    );
                  } else if (state is AuthorsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is AuthorsLoaded) {
                    return ListView.builder(
                      itemCount: state.response.docs?.length ?? 0,
                      itemBuilder: (context, index) {
                        final author = state.response.docs?[index];
                        return Card(
                          child: ListTile(
                            onTap: () {
                              if (author == null) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthorDetailsPage(authorDetails: author),
                                ),
                              );
                            },
                            title: Text(author?.name ?? ""),
                            subtitle: Text(author?.birthDate ?? ""),
                          ),
                        );
                      },
                    );
                  } else {
                    final error = state as AuthorsError;
                    return Text(error.message);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
