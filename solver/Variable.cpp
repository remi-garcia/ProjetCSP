/**
 * @file Variable.cpp
 * @date 11/12/2019 Creation
 * @brief Definitions of methods for class Variable
**/
#include "Variable.hpp"

Variable::Variable(){
  // Nothing
}

Variable::Variable(int l, int u){
  lb = l;
  ub = u;
}

Variable::Variable(int l, int u, std::vector<Constraint> cons){
  lb = l;
  ub = u;
  constraints = cons;
}

int Variable::getLB(){
  return lb;
}

int Variable::getUB(){
  return ub;
}

std::vector<Constraint> Variable::getConstraints(){
  return constraints;
}

Constraint Variable::getConstraints(int i){
  return constraints[i]
}

void Variable::setLB(int l){
  lb = l;
}

void Variable::setUB(int u){
  ub = u;
}

void Variable::setConstraints(std::vector<Constraint> cons){
  constraints = cons;
}

void Variable::adConstraint(Constraint c){
  constraints.push_back(c);
}
