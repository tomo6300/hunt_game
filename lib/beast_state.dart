class BeastState {
  List<int> currentBeastLocation;
  List<int> beastDestination;
  int hp;

  BeastState(this.currentBeastLocation, this.beastDestination, this.hp);

  void setTraps(List<int> newTraps) {
    currentBeastLocation = newTraps;
  }

  void setCropsFields(List<int> newCropsFields) {
    beastDestination = newCropsFields;
  }

  void setMoney(int newHP) {
    hp = newHP;
  }
}
