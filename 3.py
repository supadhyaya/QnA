#import givenstuff as given  # fake module that provides our needed sqlalchemy engine
import math

query = """SELECT event_id,
                  event_name,
                  uuid
           FROM   event_table_to_backup
           WHERE  event_id >= %(min_id)s
                  AND event_id < %(max_id)s""" # the logic holds invalid. Equality can be present at only one
                                                # place else duplicates records will appear in the backup.

#engine = given.get_engine()  # the SqlAlchemy engine is just there, not part of the challenge

def result_handling_function():
    # the query result handler is just there as well, not part of the challenge:
    while True:
        result = yield
        print(result)
        # Places the result in our backup

query_params = [2743139188,5644096288]

def query_runner(engine, query, query_params, result_handler):
    counter = math.ceil((query_params[1]-query_params[0])/50000)
    for iterator in range(counter):

      #Actual connection to the engine is commented out. Please uncomment it to run with your own engine
      #connection = engine.connect()

      min_id = query_params[0]+(iterator*50000)
      max_id = query_params[0]+(iterator+1)*50000

      if max_id > query_params[1]:
        max_id = query_params[1]
      else:
        pass

      print(query % {'min_id': min_id, 'max_id': max_id})

      #output = connection.execute(query % {'min_id': min_id, 'max_id': max_id})
      
      #output is used as a mock.
      output =[1,2,3]
      a = result_handler()
      next(a)
      for rows in output:
        a.send(rows)

      #connection.close()

query_runner('random',query, query_params, result_handling_function)
