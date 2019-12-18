/**
 * @file Variable.Hpp
 * @date 11/12/2019 Création
 * @brief Definition of class Variable
**/
#ifndef _VARIABLE_HPP_
#define _VARIABLE_HPP_

#include <vector>
#include "Constraint.hpp"

class Variable{
  private :
    int lb;       // Lower bound of the variable
    int ub;       // Upper bound of the variable
    std::vector<Constraint> constraints;    // All the constraint which interfere with the variable

  public :
    /**
     * @brief Constructor of an empty variable
     * @post empty variable
     *
    **/
    Variable();

    /**
     * @brief Constructor of a bounded variable
     * @pre lb <= ub
     * @post Variable bounded by [lb, ub], empty vector of constraints
     *
    **/
    Variable(int l, int u);

    /**
     * @brief Constructor of a bounded variable, with a vector of constraints
     * @pre l <= u
     * @post Variable bounded by [l, u], empty vector of constraints
     *
    **/
    Variable(int l, int u, std::vector<Constraint> cons);

    /**
     * @brief Accessor of the Lower bound
     *
    **/
    int getLB();

    /**
     * @brief Accessor of the lower bound
     *
    **/
    int getUB()

    /**
     * @brief Accessor of the vector of constraints
     *
    **/
    std::vector<Constraint> getConstraints();

    /**
     * @brief Accessor of the i.th constraint of the vector
     * @pre i < length(constraints)
     *
    **/
    std::vector<Constraint> getConstraints(int i);

    /**
     * @brief Mutator of the lower bound
     * @pre l <= ub
     * @post variable bounded by [l, ub]
     *
    **/
    void setLB(int l);

    /**
     * @brief Mutator of the upper bound
     * @pre u >= lb
     * @post variable bounded by [lb, u]
     *
    **/
    void setUB(int ub);

    /**
     * @brief Mutator of the vector
     * @post constraints = cons
     *
    **/
    void setConstraints(std::vector<Constraint> cons);

    /**
     * @brief add a constraint to constraints
     *
    **/
    void addConstraint(Constraint c);
};

#endif
