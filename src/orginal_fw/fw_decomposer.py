import sys

class FwDecompozer:
   def __init__(self, vector_table_size, vector_table_address, file):
      self.vector_table_size = vector_table_size * 4
      self.vector_table_address = vector_table_address
      self.file = open(file, 'rb')

   def save_vector_table(self, filename):
      output = open(filename, 'wb')
      self.file.seek(self.vector_table_address, 0)
      output.write(self.file.read(self.vector_table_size))
      output.close()
# After the vector table, the three parts are: the bootloader, the firmware up to dfb4 and the firmware from e074 onwards.
   def save_part1(self, filename):
      output = open(filename, 'wb')
      self.file.seek(0)
      output.write(self.file.read(self.vector_table_address)) # this would write the first 4096 bytes (the bootloader)
      output.close()

   def save_part2(self, filename):
      output = open(filename, 'wb')
      self.file.seek(self.vector_table_address + self.vector_table_size, 0) # this would be 48+4096 bytes in
      # Read the next dfb4 bytes (this is the firmware up to dfb4)
      output.write(self.file.read(0xdfb4))
      output.close()
   
   def save_part3(self, filename):
      output = open(filename, 'wb')
      self.file.seek(0xe074, 0) # this would be 57300 bytes in
      output.write(self.file.read())
      output.close()

if __name__ == '__main__':
   args = sys.argv
   fw = FwDecompozer(int(args[1]), int(args[2]), args[3])
   fw.save_vector_table(args[4])
   fw.save_part1(args[5])
   fw.save_part2(args[6])
   fw.save_part3(args[7])