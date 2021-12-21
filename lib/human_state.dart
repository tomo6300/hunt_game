class HumanState {
  List<int> traps;
  List<int> cropsFields;
  int money;

  HumanState(this.traps, this.cropsFields, this.money);

  void setTraps(List<int> newTraps) {
    traps = newTraps;
  }

  void setCropsFields(List<int> newCropsFields) {
    cropsFields = newCropsFields;
  }

  void setMoney(int newMoney) {
    money = newMoney;
  }
}
