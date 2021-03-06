#!/usr/bin/python
# -*- coding: UTF-8 -*-


from ..base import BASE


################
#  主营业务成本
################
SQL_NAME = "main_business_cost"


class MainBusinessCost(BASE):

    def __init__(self):
        super(MainBusinessCost, self).__init__(SQL_NAME)

    def __call__(self):
        data = self.get_remote_db_data()
        return data
