class Util {
  static String adaptNumFollow(double value) {
    String string;
    if (value > 0) {
      if (value >= 1000000) {
        if (value < 100000000) {
          string = '${(value / 1000000)}';
          string =
              '${string.split('.')[0]}.${string.split('.')[1].substring(0, 1)} M';
          // string = '${(value / 1000000).toStringAsFixed(1)} M ';
        } else {
          string = '${(value / 1000000).truncate()} M ';
        }
      } else {
        if (value < 100000) {
          if (value < 1000) {
            string = '${value.truncate()}';
          } else {
            string = '${(value / 1000)}';
            print(string);
            string =
                '${string.split('.')[0]}.${string.split('.')[1].substring(0, 1)} K';
            // string = '${(value / 1000).toStringAsFixed(1)} K ';
          }
        } else {
          string = '${(value / 1000).truncate()} K ';
        }
      }
    } else {
      if (value == 0) {
        string = '0';
      } else {
        string = '';
      }
    }

    return string;
  }
}
