enum SchibstedAccountState { logged_out, logged_in, unknown, canceled, fetching, error }

SchibstedAccountState getLoginStateFromString(String state) {
  state = 'SchibstedAccountState.$state';
  return SchibstedAccountState.values.firstWhere((f) => f.toString() == state, orElse: () => null);
}