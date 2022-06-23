# EB Clean CLI

![Logo](https://raw.githubusercontent.com/kishor98100/eb_clean_cli/main/doc/assets/logo-ebpearls.svg)

#### The complete Command Line Interface for creating clean architecture on flutter inspired by [Very Good CLI](https://pub.dev/packages/very_good_cli)

This is the refactored version of [Very Good CLI](https://pub.dev/packages/very_good_cli) created to match our company
standards.

## Getting Started 🚀

**❗ In order to start using EB Clean CLI you must have the [Flutter SDK](https://docs.flutter.dev/get-started/install)
installed on your
machine.**

### Installation 💻

For first time users, start by installing the [EB Clean CLI](https://github.com/kishor98100/eb_clean_cli)

```shell
dart pub global activate eb_clean_cli
```

After installation, you are good to go

```shell
eb_clean

EB Clean Command Line Interface

Usage: eb_clean <command> [arguments]

Global options:
-h, --help       Print this usage information.
    --version    Print the current version.

Available commands.dart:
  create     eb_clean create <output directory>
             Creates a new flutter project.
  generate   eb_clean generate <subcommand>
             Generates features and specific classes
  packages   eb_clean packages <subcommand>
             runs packages commands.dart
  run        eb_clean run <flavor>
             runs project with  flavor

Run "eb_clean help <command>" for more information about a command.
```

### Available commands

## eb_clean create

create a new flutter project based on provided templates, The Clean Architecture is used by default.

```shell
Creates a new flutter project.

Usage: eb_clean create <project name>
-h, --help                       Print this usage information.
-d, --desc                       The description for this new project
                                 (defaults to "A Clean Project created by EB Clean CLI.")
    --org                        The package name for this new project. Default is com.ebpearls
                                 (defaults to "com.ebpearls")
-t, --template                   The template used to generate this new project.

          [graphql] (default)    Creates a clean project with graphql as http client
          [rest]                 Creates a clean project which uses dio as http client

Run "eb_clean help" to see global options.
```

#### Usage

```shell
 # Create a new flutter app named my_app with graphql as http client 
 eb_clean create my_app --org com.my_example --desc "new flutter app"

 # Create a new flutter app named my_app with dio as http client
 eb_clean create my_app --org com.my_example --desc "new flutter app" --template rest
```

### eb_clean generate

generates feature,repository,source,model,cubit,bloc,page in specific feature or directory.

```shell
Generates features and specific classes

Usage: eb_clean generate <subcommand>
-h, --help    Print this usage information.

Available subcommands:
  bloc         eb_clean generate bloc --feature <feature-name> <name>
               creates bloc class in specific feature
  cubit        eb_clean generate cubit --feature <feature-name> <name>
               creates cubit class in specific feature
  env          eb_clean generate env
               creates .envs for all flavors
  feature      eb_clean generate feature  <name> --[no]state --[no]bloc
               generates full feature
  page         eb_clean generate page --feature <feature-name> --[no]state <name>
               creates page  in specific feature
  repository   eb_clean generate repository <name>
               creates repository class in repository packages
  source       eb_clean generate source  <name>
               generates source class in specific feature

Run "eb_clean help" to see global options.
```

#### Usage

```shell
 # generate feature named login with stateless page and cubit classes
 eb_clean generate feature login  
 
 # generate feature named login with stateful page and bloc classes
 eb_clean generate feature login --state --bloc

 # generate cubit named LoginCubit in login feature
 eb_clean generate cubit login --feature login

 # generate bloc named LoginBloc in login feature
 eb_clean generate bloc login --feature login

 # generate repository named LoginRepository's abstract and implementation in login feature
 eb_clean generate repository login --feature login

 # generate source named LoginRemoteSource's abstract and implementation in login feature
 eb_clean generate source login --feature login
   
# generate page named LoginPage as stateless widget in login feature
 eb_clean generate page login --feature login 
 
 # generate page named LoginPage as stateful widget in login feature
 eb_clean generate page login --feature login --state
 
 # create .envs for all flavors
 eb_clean generate env

```

### eb_clean packages

packages command is used to get pub dependencies and run generators

```shell
 runs packages commands

 Usage: eb_clean packages <subcommand>
  Available subcommands:
  build_runner   eb_clean packages build_runner
                 Runs flutter pub run build_runner build --delete-conflicting-outputs in current directory
  get            eb_clean packages get
                 runs flutter pub get in current directory
```

#### Usage

```shell
 # runs flutter pub get in current directory
 eb_clean packages get

 # runs flutter pub get in current directory and packages directory 
 eb_clean packages get --recursive or eb_clean packages get -r

 # runs flutter pub run build_runner build --delete-conflicting-outputs in current directory 
 eb_clean packages build_runner 

 # runs flutter pub run build_runner build --delete-conflicting-outputs in current directory and packages directory
 eb_clean packages build_runner --recursive or eb_clean packages build_runner -r
```

### eb_clean run

run the app with specific flavor

```shell
runs project with  flavor

Usage: eb_clean run <flavor>
-h, --help    Print this usage information.

Run "eb_clean help" to see global options.
```

#### Usage

```shell
#runs project on development flavor
eb_clean run

#runs project on staging flavor
eb_clean run staging

#runs project on production flavor
eb_clean run production

```

