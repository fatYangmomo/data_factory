#!/usr/bin/python
# -*- coding: UTF-8 -*-


from ..base import BASE


################
# 存货明细-进耗存
################
SQL_NAME = "inventory_details_into_the_consumption"


class InventoryDetailsIntoTheConsumption(BASE):

    def __init__(self):
        super(InventoryDetailsIntoTheConsumption, self).__init__(SQL_NAME)

    def __call__(self):
        data = self.get_remote_db_data()
        return data
