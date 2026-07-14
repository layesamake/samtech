# SAMTECH CRM

Application Flutter Android/iOS, mono-utilisateur et offline-first.

Le Sprint 0 fournit uniquement le socle : bootstrap Riverpod, navigation
go_router, architecture feature-first, thème partagé et tests de démarrage.
Aucun module métier ni stockage chiffré n'est implémenté à ce stade.

Depuis la racine du dépôt :

    dart pub get
    dart run melos run analyze
    dart run melos run test --no-select
