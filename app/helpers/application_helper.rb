module ApplicationHelper
	def need_header?
		!((controller.controller_name == "registrations" || controller.controller_name == "sessions" || controller.controller_name == "passwords") && (controller.action_name == "new" || controller.action_name == "account_regis"))
	end
end
