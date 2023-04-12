class ReputationJob < ApplicationJob
  queue_as :default # в какой очереди выполняется задача, 

  def perform(object)
    ReputationService.calculate(object) 
    # в фоне в отдельном процессе, поэтому передаётся не сам объект, 
    #а так называемая уникальная ссылка на него, это специальный объект, 
    #который генерирует ActiveJob и через которую загружается сам объект.
    #но это не работает с ассоциациями.
  end
end
