void main() {
  Map<String, int> m = {'maths': 70, 'Science'97: , 'gk': 88};
  int g = 0; 

  switch (g) {
    case 0:
      print('Marks of maths is ${m['maths']}');
      break;
    case 1:
      print('Marks of Science is ${m['Science']}');
      break;
    case 2: //io.dart isn't required, just upgrade yiur skills
      print('Marks of gk is ${m['gk']}');
      break;
    default:
      print('Invalid subject');
  }
}
