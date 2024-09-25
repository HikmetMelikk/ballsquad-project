# BallSquad Technical Test Solution

A simple application for searching authors and authors' infos.

## Used Technologies and Packages

**UI:** Flutter \
**State Management:** Bloc/Cubit \
**API Calls**: Dio

## Usage/Examples

```dart
return MultiBlocProvider(
      providers: [
        BlocProvider<AuthorsCubit>(
          create: (context) => AuthorsCubit(SampleAuthorsRepo()),
        ),
      ],
}
```

Bloc integrated to project.

```dart
abstract class AuthorsState extends Equatable {
  const AuthorsState();
  @override
  List<Object> get props => [];
}

class AuthorsInitial extends AuthorsState {
  const AuthorsInitial();
}

class AuthorsLoading extends AuthorsState {
  const AuthorsLoading();
}

class AuthorsLoaded extends AuthorsState {
  final Authors response;
  const AuthorsLoaded(this.response);
  @override
  List<Object> get props => [response];
}
```

A simple status check was written to check the status of the Bloc. An abstract class was used to make it easier to write tests. Equtable integrated to control equations.

```dart
class SampleAuthorsRepo implements AuthorsRepo {
  final baseUrl = AppConstants.baseUrl;
  late final Dio _dio;
  SampleAuthorsRepo() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );
  }

  @override
  Future<Authors> getAuthors(String value) async {
    try {
      final response = await _dio.get(value);
      if (response.statusCode == HttpStatus.ok) {
        final data = response.data;
        final Authors authors = Authors.fromJson(data);
        return authors;
      } else {
        throw NetworkError(AppConstants.errorMessage);
      }
    } catch (error) {
      throw NetworkError('Error: $error');
    }
  }
}

class NetworkError implements Exception {
  final String message;
  NetworkError(this.message);
}
```

Dio package used for API request. Also made a custom error for handle the errors. Here is example of making a request for API with Dio package.

```dart
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
```

This piece of code was written to show the writers that appeared on the screen as a result of the search.

```dart
class AppConstants {
  static String baseUrl = 'https://openlibrary.org/search/authors.json?q=';
  static String errorMessage = 'Failed to fetch authors';
  static String initialPageMessage = 'Welcome To Authors Page!\nSearch for authors to get started!';
}
```

This piece of code is written for app constants.

```dart
export 'package:flutter/material.dart';
export 'package:ballsquad_project/feature/authors/bloc/authors_cubit.dart';
export 'package:ballsquad_project/feature/authors/views/author_view.dart';
export 'package:ballsquad_project/feature/authors/repo/authors_repo.dart';
export 'package:ballsquad_project/feature/authors/bloc/authors_state.dart';
export 'package:ballsquad_project/feature/authors/model/authors.dart';
export 'package:ballsquad_project/feature/authors/views/author_detail_view.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
```

Export file was written to reduce import complexity.

## Screenshots

<div style="display: flex; gap: 10px;" >
    <img src="../ballsquad-project/assets/screenshots/home_page.png" height=400>
    <img src="../ballsquad-project/assets/screenshots/search_result.png" height=400>
    <img src="../ballsquad-project/assets/screenshots/author_detail.png" height=400>
</div>

## Demo

### Video

Watch the demo video below to see the app in action:

[![Watch the video](../ballsquad-project/assets/screenshots/screen_record.mp4)]

## Support

Send an e-mail to hikmetmelik@gmail.com for support.
