        final appState = AppState(
          isLoggedIn: true,
          tokenJwt: tokenJwt,
          entidade: entidade,
        );
        ref.watch(appStateNotifierProvider.notifier).set(
              isLoggedIn: true,
              tokenJwt: tokenJwt,
              entidade: entidade,
            );

        ref.watch(loginNotifierProvider.notifier).setTokenJwt(tokenJwt);

